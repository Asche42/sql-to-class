require 'rubygems'
require 'active_support/inflector'

class SqlToClass
  def convert(args = { :syntax => :mysql, :connection_string => nil, :with_insert => true })
    parsed_tables = parse(args[:syntax])
    final_classes = []

    required_usings = "using System;\nusing System.Data;\nusing MySql.Data.MySqlClient;\n" if args[:syntax] == :mysql

    parsed_tables.each do |parsed_table|
      table_name, attributes = parsed_table
      insert_str, values_str, arguments_str = "", "", ""
      attributes = interpret_attributes(attributes)

      cs_code = "class " + table_name.singularize + " {\n"

      # TODO : Séparer les parties liées à la création d'insert dans une autre boucle dédiée
      attributes.each do |attribute|
        cs_code << "  public " + (attribute[:type] || "NONE") + " " + (attribute[:name] || "NONE") + " { get; set; }"

        if attribute[:auto_increment]
          insert_str << "NULL"
        else
          insert_str << attribute[:name]
          values_str << "@" + attribute[:name]
          arguments_str << "    cmd.Parameters.AddWithValue(\"@#{attribute[:name]}\", #{attribute[:name]});\n"
        end

        if attribute != attributes.last
          insert_str << ", "
          values_str << ", "
        end

        cs_code << " // " + attribute[:comment] if attribute[:comment]

        cs_code << "\n"
      end

      # Inserting method
      if args[:with_insert]
        cs_code << "
  void InsertToDb() {
    MySqlConnection dbcon = new MySqlConnection(\"#{args[:connection_string] || ""}\");
    String sql = \"INSERT INTO #{table_name}(#{insert_str}) VALUES(#{values_str})\";
    MySqlCommand cmd = new MySqlCommand(sql, dbcon);

#{arguments_str}

    cmd.CommandType = CommandType.Text;
    cmd.ExecuteNonQuery();
  }
"
      end

      cs_code << "}\n"

      final_classes << cs_code
    end

    [ required_usings, final_classes ]
  end
end
