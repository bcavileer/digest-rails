require 'digest-rails/opal_lib/base_section_controller'

class Dialog < BaseSectionController
    def initialize
        super
    end

    def open(content=nil)
        link_button
        if !content.nil?
            put_content(content)
        end
        `self.$select().foundation('reveal', 'open')`
    end

    def close
        `self.$select().foundation('reveal', 'close')`
    end

    def link_button
        `self.$select('button').click(function(){
            self.$close();
        });`
    end

    def put_content(content)
        self.CC.push(name: 'content') do |fCC|
            fCC[:content] = content
        end
        render_target('content').html(content)
    end

end