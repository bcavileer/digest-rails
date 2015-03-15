    class BaseSectionController

        def initialize(config)
            @parent_section = config[:parent_section]
            @render_target = config[:render_target]
            @template = config[:template]
            @context = config[:context]
        end

        def rendering
            @template.render(@context)
        end

        def render_target
            return @render_target
        end

        def render
            Logger.log('BaseSectionController.render',self);
            @render_target.html(rendering)
        end

    end