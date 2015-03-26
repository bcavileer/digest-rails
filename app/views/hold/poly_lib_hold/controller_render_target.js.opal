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
