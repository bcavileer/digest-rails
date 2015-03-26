class RenderContext
    attr_accessor :name, :root, :render_dom, :parent_render_context
    include RenderContextHier

    def initialize(c)
        @name = c[:name]
        @root = c[:root]
        @root ||= false
        @render_dom = c[:render_dom]
        @parent_render_context = c[:parent_render_context]
    end

    def pop
        return @parent_render_context
    end

    # JS

    def push_name(n)
        push(name: n)
    end

    def new_cursor(c)
       c[:parent_render_context] = self
       self.class.new(c)
    end

    def push(c,&block)
        render_dom.push(new_cursor(c))
        if block_given?
            yield new_cursor
            new_cursor.pop
        else
            return new_cursor
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
