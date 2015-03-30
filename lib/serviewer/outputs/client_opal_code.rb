module Serviewer
  module ClientOpalCode

  def client_opal_code
    return nil
    if ['js.opal.rb','js.opal'].include? @process_map[:file].ext
      if @process_map[:file].has_path_dir('client_runtime')
        client_opal_client_runtime_code
      else
        client_opal_other_code
      end
    end
  end

  def client_opal_client_runtime_code
    @process_map.merge!(
        output_dir: client_opal_code_output_dir,
        output_file_path: @process_map[:file].file_path_for_dir( client_opal_code_output_dir, @process_map[:file].ext ),
        reason: :client_opal_other_code
    )
    copy_file
  end

  def client_opal_other_code
    @process_map.merge!(
        output_dir: client_opal_code_output_dir,
        output_file_path: @process_map[:file].file_path_for_dir( client_opal_code_output_dir, @process_map[:file].ext ),
        reason: :client_opal_other_code
    )
    copy_file
  end

  def client_opal_client_runtime_code_build_manifest
    default_build_manifest
  end
  def client_opal_client_runtime_code_build_manifest_line(process_map)
    default_build_manifest_line(process_map)
  end

  def client_opal_other_code_build_manifest
    default_build_manifest
  end

  def client_opal_other_code_build_manifest_line(process_map)
    default_build_manifest_line(process_map)
  end

end
end