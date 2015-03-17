require 'digest-rails/opal_lib/base_section_controller'

class Dialog < BaseSectionController
    def initialize
        super
    end

    def open(content=nil)
        if !content.nil?
            put_content(content)
        end
        `self.$select().foundation('reveal', 'open')`
    end

    def put_content(content)
       rt = `self.$select('content')`
       rt['render_target'].html(content)
    end

    def Xopen

       `self.$button().click(function(){
          selector.foundation('reveal', 'close');
        });`

    end

end