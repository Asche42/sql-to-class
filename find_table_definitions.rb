class SqlToClass
  private
  def find_table_definitions()
    match_iterator, parenthesis_nesting, parenthesis_met = 0, 0, false
    definitions = []
    in_table_definition = false
    current_table_definition = ""

    # For each character in the stream
    @stream.each_char do |c|
      # We compare with the pattern to check if we arrived in a table definition
      if c == MATCH_PATTERN[match_iterator] and !in_table_definition
        match_iterator += 1
      else
        match_iterator = 0
      end

      # We arrived at the end of the pattern
      if match_iterator == MATCH_PATTERN.size
        in_table_definition = true
        current_table_definition = ""
      end

      # If we are not there yet, we jump to the next iteration
      next unless in_table_definition

      # Otherwise, the whole pattern has been matched
      
      # We add the current character
      current_table_definition << c

      # We check if an open parenthesis was met
      if c == '('
        parenthesis_met = true
        parenthesis_nesting += 1
      elsif c == ')'
        parenthesis_nesting -= 1
      end

      # We met the ending parenthesis, meaning the table definition is finished
      if parenthesis_met and parenthesis_nesting == 0
        in_table_definition = false
        parenthesis_met = false
        definitions << current_table_definition
      end
    end

    definitions
  end
end
