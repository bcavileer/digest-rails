module ClientOpalCode
  def client_opal_code
      if ['js.opal.rb','js.opal'].include? @process_map[:file].ext
        @process_map.merge!(
            output_dir: client_opal_code_output_dir,
            output_file_path: @process_map[:file].file_path_for_dir( client_opal_code_output_dir, @process_map[:file].ext ),
            reason: :server_template
        )
        copy_file
      end
  end
end