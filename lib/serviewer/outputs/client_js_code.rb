module Serviewer
  module ClientJsCode

    def client_js_code
      if ['js.es6'].include? @process_map[:file].ext
        if @process_map[:file].has_path_dir('client_runtime')
          client_js_client_runtime_code
        else
          client_js_other_code
        end
      end
    end

    def client_js_client_runtime_code
      @process_map.merge!(
          js_import_lines: js_import_lines(@process_map[:file].content_lines),
          js_export_lines: js_export_lines(@process_map[:file].content_lines),
          output_dir: client_js_code_output_dir,
          output_file_path: @process_map[:file].file_path_for_dir( client_js_code_output_dir, 'js.es6' ),
          reason: :client_js_client_runtime_code
      )
      copy_file
    end

    def client_js_other_code
        @process_map.merge!(
            js_import_lines: js_import_lines(@process_map[:file].content_lines),
            js_export_lines: js_export_lines(@process_map[:file].content_lines),
            output_dir: client_js_code_output_dir,
            output_file_path: @process_map[:file].file_path_for_dir( client_js_code_output_dir, 'js.es6' ),
            reason: :client_js_other_code
        )
        copy_file
    end

    def client_js_client_runtime_code_build_manifest
      default_build_manifest
    end
    def client_js_client_runtime_code_build_manifest_line(process_map)
      default_build_manifest_line(process_map)
    end

    def client_js_other_code_build_manifest
      default_build_manifest
    end
    def client_js_other_code_build_manifest_line(process_map)
      default_build_manifest_line(process_map)
    end
  end
end