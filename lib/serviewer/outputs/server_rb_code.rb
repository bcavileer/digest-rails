module Serviewer
  module ServerRbCode
    def server_code
      if ['js.opal.rb', 'rb'].include? @process_map[:file].ext
        out_ext_first = @process_map[:file].ext.split('.')[0]

        @process_map.merge!(
            rb_require_lines: get_rb_require_lines( @process_map[:file].content_lines ),
            output_dir: server_code_output_dir,
            output_file_path: @process_map[:file].file_path_for_dir(server_code_output_dir, @process_map[:file].ext),
            reason: :server_rb_code
        )

        if out_ext_first == 'js'
          @process_map[:opal_javascript_lines] = get_opal_javascript_lines(@process_map[:file].content_lines)
          if @process_map[:opal_javascript_lines].length > 0
            process_exception(
                message: "javascript_lines are not allowed in ServerRb (.js.opal.rb) since the underlying system is Javascript files",
                process_map: @process_map
            )
          end
        end
      end
    end

    def server_rb_code_build_manifest
      default_build_manifest
    end

    def server_rb_code_build_manifest_line(process_map)
      default_build_manifest_line(process_map)
    end

  end
end