module Serviewer
  module ServerTemplate
    def server_template
      if ['js.opalerb', 'html.opalerb'].include? @process_map[:file].ext

        out_ext_first = @process_map[:file].ext.split('.')[0]
        out_ext = [out_ext_first, 'erb'].join('.')

        @process_map.merge!(
            output_dir: server_template_output_dir,
            output_file_path: @process_map[:file].file_path_for_dir(server_template_output_dir, out_ext),
            reason: :server_template
        )

        copy_file
      end
    end

    def server_template_build_manifest
      default_build_manifest
    end

    def server_template_build_manifest_line(process_map)
      default_build_manifest_line(process_map)
    end

  end
end