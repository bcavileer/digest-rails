module ClientJsCode

  def client_js_code
    if ['js.es6'].include? @process_map[:file].ext
      @process_map.merge!(
          output_dir: client_js_code_output_dir,
          output_file_path: @process_map[:file].file_path_for_dir( client_js_code_output_dir, 'js.es6' ),
          reason: :server_template
      )
      copy_file
    end
  end

end