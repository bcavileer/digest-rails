require 'digest-rails/opal_lib/base_section_controller'

class BasePaneController < BaseSectionController

    def init
        super

        scope do |pane|
            pane[:render_target] = RenderTarget.new(selector:'body')
            body[:template] = Template['digest-rails/views/pane']
        end

    end
end