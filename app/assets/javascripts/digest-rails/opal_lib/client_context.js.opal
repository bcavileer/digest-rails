class ClientContext
attr_accessor :list

    class RenderContext < Hash
        attr_accessor :name, :dir

        def initialize(c)
            @dir = c[:dir]
            @root = c[:root]
            @name = c[:name]
            @parent = c[:parent]
            super { |hash, key| hash[key] = [] }
        end

        def fullname
            [ ( @root ? nil : @parent.fullname ),name].compact.join('__')
        end

        def pop
            return @parent
        end

        def push_name(n)
            push(name: n)
        end

        def push(c)
            c[:dir] = @dir
            c[:parent] = self
            new_cursor = @dir.push(
                RenderContext.new(c)
            )

            if block_given?
                yield new_cursor
                new_cursor.pop
            else
                return new_cursor
            end

        end

        def chain(key)
            rr = chain_raw(key)
            return rr.compact.reverse.flatten
        end

        def chain_raw(key,r=[])

            r ||= []
            fetch_key_value = nil
            begin
                r << self.fetch(key)
            rescue
            end

            if !@root
                @parent.chain_raw(key,r)
            else
                r
            end
        end

        def [](key)
            value = super(key)
            if value.nil?
                value = if !@root
                    parent.get(key)
                end
            end
            return value
        end

        # JS call
        alias_method :get,:[]

        # JS call
        alias_method :set_key_value,:[]

    end

    def get(fullname)
        @list[fullname]
    end

    def init
        first_cursor = RenderContext.new(
          dir: self,
          root: true,
          name: 'root',
          parent: nil
        )
        @list = {}
        add(first_cursor)
    end

    def add(new_cursor)
        @cursor = @list[new_cursor.fullname]  = new_cursor
        return @cursor
    end

    def push(rt)
        rt_fullname = rt.fullname
        existing = @list[rt_fullname]
        @cursor = if existing.nil?
           @list[rt_fullname] = rt
        else
           existing
        end
    end

    def pop
        @cursor = @cursor.parent
    end

    def CC
        @cursor
    end

end