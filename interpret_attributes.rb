class SqlToClass
  private
  def interpret_attributes(attributes)
    cs_attributes = []

    pairs = {
      :bigint    => 'Int64',
      :smallint  => 'Int16',
      :varchar   => 'String',
      :text      => 'String',
      :int       => 'Int32',
      :mediumint => 'Int32',
      :char      => 'Char',
      :float     => 'Single',
      :double    => 'Double',
      :bool      => 'Boolean',
      :boolean   => 'Boolean',
      :tinyint   => 'SByte',
      :datetime  => 'DateTime',
      :date      => 'DateTime'
    }

    not_nullable = [ :varchar, :text ]

    attributes.each do |attribute|
      unsigned = attribute.delete(:unsigned)
      nullable = attribute.delete(:nullable)
      type     = attribute[:type]

      # TODO Improve by comparing to a “unsignable type array”
      if unsigned and type == :tinyint
        attribute[:type] = 'Byte'
      elsif unsigned and type != :char
        attribute[:type] = 'U' + pairs[type]
      else
        attribute[:type] = pairs[type]
      end

      cs_attributes << attribute
    end

    cs_attributes
  end
end
