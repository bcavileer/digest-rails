require_dependency "digest_rails/application_controller"

class DigestController < ApplicationController
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

  def digest_manifest
    digest_hash["manifest"]
  end

  def digest_manifest_core_descriptor
    digest_manifest['core_descriptor']
  end

  def digest_manifest_identifier_descriptors
    digest_manifest['identifier_descriptors']
  end

  def digest_core_hash_key
    digest_manifest_core_descriptor['hash_key']
  end

  def digest_core_raw_instances
    digest_hash[digest_core_hash_key]
  end

  def digest_core_instances
    digest_core_raw_instances.map do |digest_core_raw_instance|
      digest_core_instance(digest_core_raw_instance, digest_manifest_identifier_descriptors)
    end
  end

  def identifier_instances(identifier_key)
    digest_hash[identifier_key]
  end

  def digest_core_instance(digest_core_raw_instance, digest_manifest_identifier_descriptors)
    digest_manifest_identifier_descriptors.inject(digest_core_raw_instance.clone) do |h, digest_manifest_identifier_descriptor|
      begin
        digest_hash_key = digest_manifest_identifier_descriptor['digest_hash_key']
        identifier_hash = digest_hash[digest_hash_key]

        core_instance_hash_key = digest_manifest_identifier_descriptor['core_instance_hash_key']
        id_value = h.delete(core_instance_hash_key)
        identifier_instance = identifier_hash[id_value]

        h[digest_hash_key] = {
            identifier: identifier_instance,
            descriptor: digest_manifest_identifier_descriptor
        }
      rescue
        binding.pry
      end
      h
    end
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
  def index
    @digest_name = digest_key
    @digest_core_instances = digest_core_instances
    @digests_url = digests_url(digest_record)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: digest }
    end
  end

  # GET /digests/1
  # GET /digests/1.json
  def show
    @digest = Digest.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @digest }
    end
  end

end
