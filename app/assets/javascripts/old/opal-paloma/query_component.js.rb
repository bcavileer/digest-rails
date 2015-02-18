require 'opal'

module Paloma
  class QueryComponent

    def initialize(container,digest)
        @digest = digest
`console.log('initialize');`
        return `new Handsontable(container,self.$config());`
    end

    private

    def identifiers
      return @digest['digest'].identifiers
    end

    def max_identifier_length
      @max_identifier_index ||= identifiers.values.map{ |identifier_value|
        identifier_value.keys.length
      }.max
    end

    def data_schema_object(index)
      return "o[\"#{index}\"] = { id: null , name:null }"
    end

    def data_schema
      str = "var o = {};"
      `eval( str );`
      (0..max_identifier_length-1).each do |index|
        `eval( self.$data_schema_object(index) )`
      end
      return `o`
    end

    def col_headers
      r = []
      (0..self.max_identifier_length-1).each do |index|
        r << index.to_s
      end
      return r
    end

    def column_object(index)
      str = "var o = { data : \"#{index}.name\" }"
      return str
    end

    def columns
      return (0..self.max_identifier_length-1).map do |index|
        `eval( self.$column_object(index) );`
        `o`
      end
    end

    def data_object(o,identifier_key,index)
      v = identifiers[identifier_key][index]
      r = "o[\"#{index}\"] = v"
      `eval(r);`
    end

    def data_for(identifier_key)
      str = "var o = {};"
      `eval( str );`
      o = `o`
      (0..max_identifier_length-1).each do |index|
        data_object(o,identifier_key,index)
      end
      return `o`
    end

    def data
        d = identifiers.keys.map do |identifier_key|
          data_for(identifier_key)
        end
        return d
    end

    def config
      c = `{
            colHeaders: self.$col_headers(),
            columns: self.$columns(),
            dataSchema : self.$data_schema(),
            data : self.$data(),
            //startRows: 10,
            //startCols: 53,
            minSpareRows: 1
      }`
      return c
    end

  end
end