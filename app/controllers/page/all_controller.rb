require 'axle/concern/server/digests_controller_helper'
require 'axle/concern/ui/layouts_helper'
require 'axle/core/digests'

module Page
  class AllController < ::ActionController::Base
    include Axle::Concern::Server::DigestsControllerHelper

    layout 'digest-rails/application'

    before_filter :prepare_digests

    def prepare_digests
      view_context.class.include(Axle::Concern::Ui::LayoutsHelper)
      @digests =  Axle::Core::Digests[].digests
      @digest_view_template = "digest-rails/shared/digest"
    end

    def add_layout_rendering(pane_rendering)
      {
          navigation: 'Nav from layout'
      }
    end

    def render_for_main_pane(main_pane_rendering)
      main_pane_rendering.merge!(
          add_layout_rendering(main_pane_rendering)
      )
    end

    def name_server
      render :text => "Route:#{get_route}"
    end

    private

=begin
    def navigation
      @navigation = "NN from Layout Controller"
    end

    def main_pane
      @main_pane = "PP from Controller"
    end
=end

  end
end
