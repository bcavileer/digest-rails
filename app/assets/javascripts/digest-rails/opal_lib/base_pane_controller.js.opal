require 'template'
require 'axle/opal_lib/data_source'
require 'digest-rails/opal_lib/core_pane_controller'
require 'digest-rails/opal_lib/base_section_controller'

class BasePaneController < CorePaneController

    def init
        super

        ClientContext.push(:header) do |fCC|
            fCC[:controller] = LocationPaneletController.new
            fCC[:template] = Template['digest-rails/views/pane_header']
            fCC[:render_target] = RenderTarget.new(selector: '.header')
        end

        ClientContext.push(:body) do |fCC|
            fCC[:controller] = LocationPaneletController.new
            fCC[:template] = Template['digest-rails/views/pane_body']
            fCC[:render_target] = RenderTarget.new(selector: '.body')
        end

        ClientContext.push(:footer) do |fCC|
            fCC[:controller] = LocationPaneletController.new
            fCC[:template] = Template['digest-rails/views/pane_footer']
            fCC[:render_target] = RenderTarget.new(selector: '.footer')
        end

    end
end