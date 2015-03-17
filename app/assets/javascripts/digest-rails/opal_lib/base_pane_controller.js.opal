require 'template'
require 'axle/opal_lib/data_source'
require 'digest-rails/opal_lib/core_pane_controller'
require 'digest-rails/opal_lib/base_section_controller'

class BasePaneController < CorePaneController
    def init
        super
        Logger.log('BasePaneController.init',self);
        CC = ClientContext.push(:base_pane)
        CC.push(self)

        CC = ClientContext.push_y(:header)
        CC[:controller] = LocationPaneletController.new
        CC[:template] = Template['digest-rails/views/pane_header']
        CC[:render_target] = RenderTarget.new(selector: '.header')
        CC.pop

        CC = ClientContext.push_y(:body)
        CC[:controller] = LocationPaneletController.new
        CC[:template] = Template['digest-rails/views/pane_body']
        CC[:render_target] = RenderTarget.new(selector: '.body')
        CC.pop

        CC = ClientContext.push_y(:footer)
        CC[:controller] = LocationPaneletController.new
        CC[:template] = Template['digest-rails/views/pane_footer']
        CC[:render_target] = RenderTarget.new(selector: '.footer')
        CC.pop

    end

end