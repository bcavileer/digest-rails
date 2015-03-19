require 'digest-rails/opal_lib/base_section_controller'

class DialogController < BaseSectionController
    attr_accessor :content, :button

    class ContentController < BaseSectionController
        template Template['digest-rails/views/dialog']
    end

    class ButtonController < BaseSectionController
    end

    def initialize(c)
        super
        @content = ContentController.new(name: :content, context: self.get_context )
        @button = ButtonController.new(name: :button, context: self.get_context )
    end

    def show_text(text)
        content.render(text: text)
        link_close_button
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