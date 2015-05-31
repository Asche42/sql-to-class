# Main definition of the SqlToClass program

class SqlToClass
  MATCH_PATTERN = "CREATE TABLE" # The pattern which defines the beginning of a table definition.

  def initialize(file_path)
    @stream = File.read file_path
  end
end

load 'find_table_definitions.rb'
load 'parse.rb'
load 'interpret_attributes.rb'
load 'convert.rb'
