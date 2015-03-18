require 'digest-rails/opal_lib/render'

class BaseSectionController
    #include Render

    def initialize(c)
        Logger.log('BaseSectionController render_context',c[:render_context]);
        @CC_fullname = c[:render_context].fullname
        @CC_dir = c[:cc_dir]
    end

    def select(path=nil)
        r = nil
        if path.nil?
            r = `$( self.$render_target(self.$CC() ).selector)`
        else
            self.CC.push(name: path) do |fCC|
                r = `$(self.$render_target_raw(fCC).selector)`
            end
        end
        return r
    end

    def render_target(path=nil)
        r = nil
        if path.nil?
            r = render_target_raw(self.CC)
        else
            self.CC.push(name: path) do |fCC|
                r = render_target_raw(fCC)
            end
        end
        return r
    end

    def render_target_raw(cc)
        rt_os = cc.chain(:render_target)
        rt_selectors = rt_os.map{ |rto|
            rto.selector
        }
        rt_selector = rt_selectors.join(' > ')
        rt = RenderTarget.new(selector: rt_selector)
        return rt
    end

    def CC
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