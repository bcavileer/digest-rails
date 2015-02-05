require 'opal'

module Paloma
  class ListComponent

    def initialize(container,digest)
      @digest = digest
      return `new Handsontable(container,self.$config());`
    end

    private

    def attributes
      return @digest['digest'].attributes
    end

    def instances
      return @digest['digest'].instances
    end

    def identifiers
      return @digest['digest'].identifiers
    end

    ###############

    def data_schema
      r = {}
      @digest['digest'].identifiers.keys.each{ |k| r[k] = nil }
      return r
    end

    def columns
      return attributes.keys.map do |attribute_key|
        attribute = attributes[attribute_key]
        str = "var o = { data: \"map.#{attribute_key}\"}"
        `eval(str)`
        `o`
      end
    end

    def typeof(js_name)
      str = "typeof #{js_name}"
      return `eval(str)`
    end

    def col_headers
      return attributes.keys.map do |attribute_key|
        attribute = attributes[attribute_key]

        identifier = `attribute.identifier`
        typeof_identifier = `typeof identifier`

        if `typeof_identifier == 'boolean'` and `identifier == true`
          table = `attribute.table`
        else
          attribute_key
        end

      end
    end

    def data_for(instance)
      typeof_instance = `typeof instance`
      r = {}
      if `typeof_instance != 'undefined'`

        attributes.keys.map do |attribute_key|
          attribute = attributes[attribute_key]

          identifier = `attribute.identifier`
          typeof_identifier = `typeof identifier`
          raw = `instance[attribute_key]`
          r[attribute_key] = if `typeof_identifier == 'boolean'` and `identifier == true`
            table = `attribute.table`
            obj = identifiers[table][raw]
            typeof_obj = `typeof obj`
            if `typeof_obj == 'object'`
              `obj.name`
            else
              ''
            end
          end

        end
      end
      r
    end

    def data
      return instances.keys.map do |instance_key|
        data_for( instances[instance_key] )
      end
    end

    def config
      c = `{
            columns: self.$columns(),
            colHeaders: self.$col_headers(),
            //dataSchema : self.$data_schema(),
            data : self.$data(),
            //data : [{id:11111},{id:222}],
            //startRows: 5,
            //startCols: 5,
            //minSpareRows: 1
      }`
      `console.log('config')`
      `console.log(c)`
      return c
    end

  end
end