require_dependency "digest_rails/pane/main_controller"
require_dependency "axle/route/dir"

module DigestRails
  class DigestController < Pane::MainController
    before_filter :prepare_digest

    def prepare_digest

      @active_digest_name = self.class.to_s.split('::').last.underscore.split('_')[0..-2].join('_')
      @active_digest = @digests_crosses[:digests].select{ |d| d.key.underscore == @active_digest_name }.first
      @active_digest_index = @active_digest.instance_variable_get(:@index)

    end

    def json

      render json: @digests_crosses[:digests][@active_digest_index]

    end

    def show_response

      endpoint = @active_digest.data_view.core_set.endpoint
      model_name = @active_digest.data_view.core_set.item_hash.key.to_s.split('/')[1..-1].join('_')
      digest_json_url = get_route(engine: endpoint.engine, route_name: [@active_digest_name,'json'].join('_') )
      core_set_html_url = get_route(engine: endpoint.engine, route_name: model_name )

      @response_params.merge(
          engine: endpoint.engine,
          digest_name: @active_digest_name.split('_').first,
          active_digest_index: @active_digest_index,
          digest_json_url: digest_json_url,
          core_set_html_url: core_set_html_url
      )

    end

    def show
      render :text => Template.paths
      #js 'Digest#show',show_response

    end

  end
end