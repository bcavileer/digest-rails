module Paloma
  class DigestDecode
    attr_accessor :tables, :top_name

    def decode(top_name_str,data)
      self.tables = s2s(data)
      self.top_name = decode_string(top_name_str)
      return self
    end

private

    def decode_array(a)
      a.map { |i| s2s(i) }
    end

    def decode_type(type,value)
        case type
          when 'ActiveSupport::TimeWithZone'
            return `eval(value)`
          when 'Symbol'
            return `eval(value)`
          when 'Fixnum'
            return `parseInt( eval(value) )`
          when 'FalseClass'
            return false;
          when 'TrueClass'
            return true;
          when 'NilClass'
            return `null`;
          else
            #Should raise
        end
    end

    def decode_raw_string(str)
      # To Provide hooks?
      case str
        when 'Fixnum'
          return str
        when 'Integer'
          return str
        when 'Authorization::User::ArGuest'
          return str
        else
          return str
      end
    end

    def decode_string(str)
      re = `/__(.*)\[(.*)\]/`
      m_type = `str.match(re)`
      if `m_type != null`
        return decode_type(m_type[1],m_type[2])
      else
        return decode_raw_string(str)
      end
    end

    def decode_object(obj)
      result = `{};`
      `$.each( obj, function( key, value ) {
//console.log('key: '+ key, ' value: ',value);
        result[key] = self.$s2s(value);
      });`
      return result
    end

    def base_type_of(v)
      return `typeof v;`
    end

    def constructor_of(v)
      if `v.constructor === Array`
        'array'
      else
        'unknown'
      end
    end

    def type_of(v)
      type = base_type_of(v)
      case type
        when 'undefined'
          return type # Should raise
        when 'string'
          return type
        when 'object'
          constructor = constructor_of(v)
          case constructor
            when 'array'
              return constructor
            else
              return type
          end
        else
          return type
        end
    end

    def s2s(h)
      tov = type_of(h)
      case tov
        when 'array'
          return decode_array(h)
        when 'object'
          return decode_object(h)
        when 'string'
          return decode_string(h)
      end
    end

  end
end
