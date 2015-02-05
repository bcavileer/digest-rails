#require 'ember_data'
require 'opal'
require 'opal-paloma/query_component'


module Paloma
  class Digest
    attr_reader :name, :instances, :identifiers, :attributes

    def initialize(decoded)
      @name = `decoded.top_name;`
      @decoded = `decoded.tables;`
    end

    def to_hash(hash,key,value)
      hash[key] = value
    end

    def get_table(table_name)
      table = {}
      `$.each( this['decoded'][table_name],
        ( function(index){
          self.$to_hash(table,index,this['decoded'][table_name][index] )
        }.bind(self) )
      )`
      return table
    end

    def attribute( key, value )
      @attributes[key] = value;
      if `value == null`
        return
      elsif `value.table != null`
        if `value.identifier != null`
          @identifiers[`value.table`] = get_table(`value.table`)
        elsif `value.identifiers != null`
          @identifiers[`value.table`] = get_table(`value.table`)
        end
      elsif `value.direct != null`
      else
        #raise?
      end
    end

    def process_identifiers
      @identifiers = {}
      attributes_object = `self['decoded']['digest']['attributes'];`
      @attributes = {}
      `for( a in attributes_object ) {
          this.$attribute(a,attributes_object[a]);
      }`
    end

    def process_instances
      @instances = {}
      `this['decoded'][ this['name'] ]`.each do |instance|
        @instances[`instance.id`] = instance
      end
    end

    def process
      process_identifiers
      process_instances
      `delete self.decoded`
      return `this`
    end

  end
end
