require 'digest-rails/opal_lib/base_section_controller'

class BasePaneController < BaseSectionController

    attr_accessor :header, :pane, :footer

    class HeaderController < BaseSectionController
        template Template['digest-rails/views/pane_header']
    end

    class PaneController < BaseSectionController
        #template Template['digest-rails/views/pane_body']
    end

    class FooterController < BaseSectionController
        template Template['digest-rails/views/pane_footer']
    end

    def initialize(c)

        # Attach to DOM
        c[:context] = context

        super

        @header = HeaderController.new( name: :header, context: context )
        @pane = PaneController.new( name: :pane, context: context )
        @footer = FooterController.new( name: :footer, context: context )

    end

    # DOM Reference
    def context
        ::ClientContext.references[:pane_context]
    end

end