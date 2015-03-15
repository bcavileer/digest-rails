    class BaseSectionController
        attr_reader :parent_section, :render_target, :template, :context

        def initialize(config)
            @parent_section = config[:parent_section]
            @render_target = config[:render_target]
            @template = config[:template]
            @context = config[:context]
        end

        def render_target
            return @render_target
        end

        def render
            Logger.log('BaseSectionController.render',self);

            if @render_target.nil?
                raise 'No render_target'

            elsif @render_target.respond_to? :html
                @render_target.html( @template.render( @context ) )

            elsif !@render_target.parent.nil?
                @render_target.parent.html( @template.render( @context ) )
                @render_target.children.values.each do |child|
                    child.render
                end
            else
                raise 'No rendering done'
            end
        end

    end