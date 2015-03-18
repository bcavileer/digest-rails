require 'digest-rails/opal_lib/base_section_controller'

class BasePaneController < BaseSectionController

    def process_user_request(user_request)
        console.log("user_request:", user_request)
    end

    def init
        super
        scope do |pane|
            pane[:render_target] = RenderTarget.new(selector:'body')
            body[:template] = Template['digest-rails/views/pane']
        end
    end

end