module ControllerContext

    class SourceContext

        def init(config)
            @defined_context = config[:context]
            return self
        end

        def get
            ( @defined_context ? @defined_context : ::ClientContext.references[:first_cursor] )
        end

    end

    class ControllerContext

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

    class ControllerRenderTarget

        def init(c)
            @configuration = c[:configuration]
            @source_context = c[:source_context]
            @controller_context = c[:controller_context]
            return self
        end

        def get
            RenderTarget.new(selector: selector)
        end

        private

        def selector
            render_target_selectors.join(' > ')
        end

        def render_target_selectors
            render_target_array.map do |rt|
                rt.selector
            end
        end

        def render_target_array
            hit_absolute = false
            render_targets = []
            @controller_context.get.ancestory.map do |ctx|
                Logger.log("ctx: ",ctx)
                if !hit_absolute
                    rta = ctx[:render_target_absolute]
                    rtr = ctx[:render_target_relative]
                    if rta and rtr
                        Logger.log("Context with RenderTarget issue: ",ctx)
                        raise "Context can have only only one RenderTarget with a relative OR absolute selector"
                    end
                    render_targets << rta
                    render_targets << rtr
                    hit_absolute = true if rta
                 end
            end.compact.flatten
        end

     end

    def initialize(c)
        raise 'Controller instance name required (ie dialog_0)' if !c[:name]
        @source_context = SourceContext.new.init(c)

        @controller_context = ControllerContext.new.init(
            name: c[:name],
            selector: c[:selector],
            controller: self,
            source_context: @source_context
        )

        @controller_render_target = ControllerRenderTarget.new.init(
            config: c,
            source_context: @source_context,
            controller_context: @controller_context
        )
    end

    def scope
        yield self, @controller_context.get
        return self
    end

    def get_render_target
        @controller_render_target.get
    end

    def get_context
        @controller_context.get
    end

end