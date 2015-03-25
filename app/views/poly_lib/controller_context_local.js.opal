class ControllerContextLocal

    attr_reader :render_target_absolute, :render_target_relative

    def init(config)
        @name = config[:name]
        raise "ControllerContext requires name" if @name.nil?
        @source_context = config[:source_context]
        @context = @source_context.get.push(name: @name)
        set_context_value( :controller, config[:controller] )
        set_render_target( config[:selector] )
        return self
    end

    def set_render_target(config_selector)

 Logger.log('config_selector',config_selector)
 Logger.log('name',@name)

        if config_selector
            if config_selector.include?('#')
                    @render_target_absolute =
                    set_context_value( :render_target_absolute, RenderTarget.new( selector: config_selector ) )
            else
                @render_target_relative =
                    set_context_value( :render_target_relative, RenderTarget.new( selector: config_selector ) )
            end
        else
            @render_target_relative =
                set_context_value( :render_target_relative, RenderTarget.new( selector: ".#{@name}" ) )
        end
    end

    def get
        client_context_dir.list[client_context_fullname]
    end

    private

    def set_context_value(value_key, value)
        client_context_dir.set_context_value_key(
            client_context_fullname,
            value_key,
            value
        )
    end

    def client_context_dir
        @source_context.get.dir
    end

    def client_context_fullname
        @context.fullname
    end

end

