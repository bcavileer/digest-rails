module DigestRails
  class ApplicationController < ActionController::Base

    def get_digests
      @digests ||= Axle::Core::Digests[]
    end

    def get_route()
      wo_parens
    end

    private

    def http_host_split
      request.env["HTTP_HOST"].split(':')
    end

    def http_base
      http_host_split[0].split('.')[-2..-1].join('.')
    end

    def http_port
      http_host_split[1]
    end

    def engine_map
      Axle::Route::Dir.engine_map(params[:engine].to_sym)
    end

    def engine_route_name
      [ params[:engine] , params[:route_name] ].join('.')
    end

    def template
      engine_map[ engine_route_name ]
    end

    def with_parens
      template.gsub('HOST', "#{http_base}:#{http_port}")
    end

    def wo_parens
      m = with_parens.match(/(.*)\((.*)\)/)
      return m[1]
    end

  end

end
