require 'digest-rails/opal_lib/base_section_controller'

class Dialog < BaseSectionController
    def initialize
        super
    end

    def open

        `self.$select().foundation('reveal', 'open')`
    end

    def content_select
        box_selector = self.render_target.selector
        CC.push(:content) do
        end

        box_rt = self.render_target
        box_selector = self.render_target.selector
        `$(box_selector)`
    end

    def Xopen

       `self.$button().click(function(){
          selector.foundation('reveal', 'close');
        });`

    end

end