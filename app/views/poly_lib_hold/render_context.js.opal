class RenderContext < Hash
    attr_accessor :name, :dir, :parent
    
    def initialize(c)
        @dir = c[:dir]
        @root = c[:root]
        @root ||= false

        @name = c[:name]
        @parent = c[:parent]
        super { |hash, key| hash[key] = [] }
    end

    def point_context
        self
    end

    def open_struct
        os = OpenStruct.new( flattened_context )
    end

    def flattened_context
        @dir.flattened_context( self.clone )
    end

    def fullname
        [ ( @root ? nil : @parent.fullname ), name ].compact.join('__')
    end

    def ancestory
        [ ( @root ? nil : @parent ), self ].compact.flatten
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

        new_cursor = @dir.push( RenderContext.new(c) )

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
