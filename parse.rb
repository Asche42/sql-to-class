class SqlToClass
  private
  def parse(syntax = :mysql)
    mysql_format_regex = /^ *`([A-Za-z0-9_-]+)` ([A-Za-z]+)(\([0-9]+\))? ?(NULL)? ?(unsigned)? ?(DEFAULT)? ?(NOT)? ?(NULL)? ?(AUTO_INCREMENT)?(COMMENT '(.*)')?,?$/i
    mysql_table_name   = /^.*`([A-Za-z0-9_-]+)` \($/i

    parsed_tables = []

    tables = find_table_definitions()
    return nil unless tables

    tables.each do |table|
      table_name = ""
      attributes = []

      table.each_line do |line|
        result_table_name = mysql_table_name.match(line)
        result_attribute  = mysql_format_regex.match(line)

        table_name = result_table_name[1] if result_table_name and result_table_name[1]

        if result_attribute
          current_attribute = {}

          current_attribute[:name] = result_attribute[1] if result_attribute[1]
          current_attribute[:type] = result_attribute[2].downcase.to_sym if result_attribute[2]
          current_attribute[:unsigned] = (result_attribute[5] and result_attribute[5].upcase == "unsigned")
          current_attribute[:nullable] = (result_attribute[7] and result_attribute[7].upcase != "NOT")
          current_attribute[:comment]  = result_attribute[11]
          current_attribute[:auto_increment] = (result_attribute[9] and result_attribute[9].upcase == "AUTO_INCREMENT")

          attributes << current_attribute
        end
      end

      parsed_tables << [ table_name, attributes ]
    end

    parsed_tables
  end
end
