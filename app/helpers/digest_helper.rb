module DigestHelper

  def digest_key
    @digest_key
  end

  def digest_core_raw_instances
    @digest_hash[digest_core_hash_key]
  end

  def digest_manifest
    @digest_hash["manifest"]
  end

  def digest_core_descriptor
    digest_manifest['core_descriptor']
  end

  def digest_core_hash_key
    digest_core_descriptor['hash_key']
  end

  def digest_identifier_descriptors
    digest_manifest['identifier_descriptors']
  end

  def identifier_instances(identifier_key)
    @digest_hash[identifier_key]
  end

  def digest_core_instances
    digest_core_raw_instances.map do |digest_core_raw_instance|
      digest_core_instance(digest_core_raw_instance)
    end
  end

  def digest_core_instance(digest_core_raw_instance)
    digest_identifier_descriptors.inject(digest_core_raw_instance.clone) do |h, digest_identifier_descriptor|
      begin
        digest_hash_key = digest_identifier_descriptor['digest_hash_key']
        identifier_hash = @digest_hash[digest_hash_key]

        core_instance_hash_key = digest_identifier_descriptor['core_instance_hash_key']
        id_value = h.delete(core_instance_hash_key)
        identifier_instance = identifier_hash[id_value]

        h[digest_hash_key] = {
            identifier: identifier_instance,
            descriptor: digest_identifier_descriptor
        }
      rescue
        binding.pry
      end
      h
    end
  end

end