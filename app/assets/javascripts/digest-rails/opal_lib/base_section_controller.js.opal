require 'digest-rails/opal_lib/render'

class BaseSectionController
    #include Render

    def initialize(c)
        Logger.log('BaseSectionController render_context',c[:render_context]);
        @CC_fullname = c[:render_context].fullname
        @CC_dir = c[:cc_dir]
    end

    def xxselect(path='.')
        return raw_select
        r = nil
        if path == '.'
            r = raw_select
        else
            CC.push(path) do
                r = raw_select
            end
        end
        return r
    end

    def select
        `$(self.$render_target().selector)`
    end

    def render_target
        rt_os = self.CC.chain(:render_target)
        rt_selectors = rt_os.map{ |rto|
        Logger.log('RTO',rto.selector);
            rto.selector
        }
        rt_selector = rt_selectors.join(' > ')
        rt = RenderTarget.new(selector: rt_selector)
        return rt
    end

    def CC
Logger.log('CC called');
        @CC_dir.get(@CC_fullname)
    end

    def xrender
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