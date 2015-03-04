require 'axle/concern/server/digests_controller_helper'
require 'axle/concern/ui/layouts_helper'
require 'axle/concern/ui/menu_tree'
require 'axle/core/digests'

module DigestRails
module Page
  class AllController < ::ActionController::Base
    include Axle::Concern::Server::DigestsControllerHelper
    include Axle::Concern::Ui::MenuTree

    layout 'digest_rails/page/application'

    before_filter :prepare_digests

    def prepare_digests
      @title = 'Holman Digester'
      view_context.class.send(:include,Axle::Concern::Ui::LayoutsHelper)
      @digests_crosses =  Axle::Core::Digests[].digests_crosses
      @response_params = {
          digests_crosses_json_url: get_route(engine: 'digest_rails', route_name: 'digests_crosses_json' )
      }
      @digests = @digests_crosses[:digests]
      @digest_view_template = "digest-rails/shared/digest"
    end

    def digests_crosses_json
      render json: Axle::Core::Digests[].digests_crosses.as_json
    end

    def name_server
      render :text => "Route:#{get_route}"
    end

    private

  end
end
end
