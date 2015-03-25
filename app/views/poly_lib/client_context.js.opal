#require 'ostruct'
require 'digest-rails/poly_lib/render_target'

class ClientContext
    attr_accessor :list, :references, :cursor

    def set_context_value_key( context_fullname, value_key, value )
        r = @list[context_fullname][value_key] = value

# if value_key == :render_target_absolute
#    Logger.log("---------set_context context_fullname: #{context_fullname}, value_key: #{value_key}, value: #{value}",r);
# end

        r
    end

    def get(fullname)
        @list[fullname]
    end

    def init
        @list = {}
        @references = {}

        first_cursor = RenderContext.new(
          dir: self,
          root: true,
          name: 'root',
          parent: nil
        )

        add( references[:first_cursor] = first_cursor )
    end

    def add(new_cursor)
        @cursor = @list[new_cursor.fullname]  = new_cursor
        return @cursor
    end

    def push(rt)
Logger.log('rt',rt)
        rt_fullname = rt.fullname
        existing = @list[rt_fullname]
        @cursor = if existing.nil?
Logger.log('push to NEW context',rt_fullname)
           @list[rt_fullname] = rt
        else
Logger.log('push to Existing context',rt_fullname)
           existing
        end
    end

    def pop
        @cursor = @cursor.parent
    end

    def flattened_context(cc)
        cc.ancestory.inject(RenderContext.new({})) do |context,flat|
            flat.merge! context
            flat
        end
    end

end


