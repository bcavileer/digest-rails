require 'template'
require 'axle/opal_lib/data_source'
require 'digest-rails/opal_lib/core_pane_controller'
require 'digest-rails/opal_lib/base_section_controller'

class BasePaneController < BaseSectionController

    class BodyController < BaseSectionController
    end

    class HeaderController < BaseSectionController
    end

    class FooterController < BaseSectionController
    end

    def init
        super

        scope do |pane|
            pane[:render_target] = RenderTarget.new(selector:'body')
            body[:template] = Template['digest-rails/views/pane']
        end

        BodyController.new( name: :body, context: self.get_context ).scope do |body|

            body[:render_target] = RenderTarget.new(selector:'body')
            body[:template] = Template['digest-rails/views/pane']

            dialog.push(name: :content) do |content|
                content[:render_target] = RenderTarget.new(selector:'.content')
            end

            dialog.push(name: :button) do |button|
                button[:render_target] = RenderTarget.new(selector: 'a.custom-close-reveal-modal')
            end

        end

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