require 'axle/concern/server/digests_controller_helper'
require 'axle/concern/ui/layouts_helper'
require 'axle/core/digests'

module Page
  class AllController < ::ActionController::Base
    include Axle::Concern::Server::DigestsControllerHelper
    include Axle::Concern::Ui::MenuTree

    layout 'digest-rails/application'

    before_filter :prepare_digests

    def prepare_digests
      @title = 'Holman Digester'
      view_context.class.include(Axle::Concern::Ui::LayoutsHelper)
      @digests =  Axle::Core::Digests[].digests
      @digest_view_template = "digest-rails/shared/digest"
    end

    def name_server
      render :text => "Route:#{get_route}"
    end

    private

  end
end
