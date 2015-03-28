module Serviewer
  module BuildManifests

    def build_manifests
      @process_map_reason_hash.keys.each do |k|
        @post_process_reason = k
        @post_process_maps = @process_map_reason_hash[k]
        build_manifest_method = "#{k}_build_manifest".to_sym
        self.send( build_manifest_method )
      end
    end

    def default_build_manifest
      p @post_process_reason
      build_manifest_line_method = "#{@post_process_reason}_build_manifest_line".to_sym

      @post_process_maps.each_pair do |key,process_map|
        self.send( build_manifest_line_method, process_map )
      end
    end

    def default_build_manifest_line(process_map)
      file = process_map[:file]
      exceptions = process_map[:exceptions]

      p "  #{process_map[:file].key} "
      p "    gem: #{process_map[:file].gem_name} "
      p "    in: #{process_map[:file].file_path} "
      p "    out: #{process_map[:output_file_path]} "
      print_exception(exceptions,6) if exceptions

    end
  end
end