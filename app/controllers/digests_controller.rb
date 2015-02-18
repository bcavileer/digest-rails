require_dependency "digest_rails/application_controller"
require 'axle/route/dir'


class DigestsController < DigestRails::ApplicationController
  layout 'digest-rails/application'

  def index
    get_digests
    #render :text => "Available Digests #{@digests.keys}"
  end

  def name_server
    render :text => "Route:#{get_route}"
  end

end

=begin
  class DigestsController #< DigestRails::ApplicationController
    #layout 'digest-rails/application'

    def digest_keys
      DigestRails::Digest.select('key').uniq.map{|r| r.key}
    end

    def raw_digest(key)
      DigestRails::Digest.where(:key => key).order("created_at").last
    end

    def url_subdomain(a_raw_digest)
      a_raw_digest.url_subdomain
    end

    def server_name
      r = request.env["SERVER_NAME"]
      rsplit = r.split('.')
      r = rsplit[1..-1].join('.') if rsplit.length > 2
      return r
    end

    def server_port
      request.env["SERVER_PORT"]
    end

    def url_path(a_raw_digest)
      rsplit = a_raw_digest.path_repl_command.split('.')
      rsplit[-1].split('_')[0..-2].join('_')
    end

    def digest_url(a_raw_digest)
      "http://#{a_raw_digest.url_subdomain}.#{server_name}:#{server_port}/#{url_path(a_raw_digest)}"
    end

    def link_urls(a_raw_digest)
      a_raw_digest.instance_variable_set( :@url, digest_url(a_raw_digest) )
    end

    def digests
      @digests =  digest_keys.map do |key|
        r = raw_digest(key)
        link_urls(r)
        r
      end
    end

    # GET /digests
    # GET /digests.json
    def index
      @digests = digests
  
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @digests }
      end
    end

  end
=end
