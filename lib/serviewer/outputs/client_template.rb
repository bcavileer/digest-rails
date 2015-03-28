module Serviewer
  module ClientTemplate

    def client_template
      if ['js.opalerb', 'html.opalerb'].include? @process_map[:file].ext
        @process_map.merge!(
            output_dir: client_template_output_dir,
            output_file_path: @process_map[:file].file_path_for_dir(client_template_output_dir, @process_map[:file].ext),
            reason: :client_template
        )
        copy_file
      end
    end

    def client_template_build_manifest
      default_build_manifest
    end

    def client_template_build_manifest_line(process_map)
      default_build_manifest_line(process_map)
    end

  end
end