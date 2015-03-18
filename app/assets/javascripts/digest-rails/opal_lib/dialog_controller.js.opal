require 'digest-rails/opal_lib/base_section_controller'

class DialogController < BaseSectionController
    attr_accessor :button

    class ButtonController
        include ControllerContext
    end

    def initialize(c)
        super
        @button = ButtonController.new(name: :button, context: self.get_context )
    end

    def show_text(text)
        content.scope do |cc|
            cc[:text] = 'Loading Opal App...'
        end
        render
    end

    def render
        super
        open
    end

    def open
        link_close_button
        Element.find(selector).foundation('reveal', 'open')
    end

    def close
        Element.find(selector).foundation('reveal', 'close')
    end

    def link_close_button
        me = self
        #Element.find(button.selector).click { me.$close() }
        `$(self.button.$selector()).click(function(){me.$close()})`
    end

end