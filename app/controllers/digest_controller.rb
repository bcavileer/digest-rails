require_dependency "digest_rails/application_controller"

class DigestController# < DigestRails::ApplicationController
  layout 'digest-rails/application'

  def digest_key
    "Must override"
  end

  def digest_record
    DigestRails::Digest.where(:key => digest_key).order("created_at").last
  end

  def digest_hash
    JSON.parse(digest_record.data)
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

  def url_subdomain
    'digest_rails'
  end

  def digests_url(a_raw_digest)
    "http://#{url_subdomain}.#{server_name}:#{server_port}/digests"
  end

  # GET /digests
  # GET /digests.json
  def show
    @digest_key = digest_key
    @digest_hash = digest_hash
    @digests_url = digests_url(digest_record)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: digest }
    end
  end


end
