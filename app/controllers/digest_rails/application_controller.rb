module DigestRails
  class ApplicationController < ActionController::Base

    def get_digests
      @digests ||= Axle::Core::Digests[]
    end

    def get_route()
      host_base = request.env["SERVER_NAME"].split('.')[-2..-1].join('.')
      port = request.env["SERVER_PORT"]
      template = Axle::Route::Dir.engine_map( params[:engine].to_sym )[ [params[:engine],params[:route_name]].join('.') ]
      with_parens = template.gsub('HOST',"#{host_base}:#{port}")
      m = with_parens.match(/(.*)\((.*)\)/)
      return m[1]
    end

  end
end
