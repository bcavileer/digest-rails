require 'digest-rails/opal_lib/controller_context'

class BaseSectionController
    include ControllerContext
    attr_accessor :content

    class ContentController
        include ControllerContext
        def get
            r = nil
            scope do |cc|
                r ||= cc[:text]
                r ||= cc[:html]
                if t = cc[:template]
                    r ||= t.render(cc)
                end
            end
            return r
        end
    end

    def initialize(c)
        Element.expose :click
        Element.expose :foundation
        super
        @content = ContentController.new( name: :content, context: self.get_context )
    end

    def render
        render_content
    end

    def render_content
        content.render_target.html(content.get)
    end

end