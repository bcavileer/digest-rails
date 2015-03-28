module ServerRbCode
    def server_code
      if ['js.opal.rb','rb'].include?  @process_map[:file].ext
        @process_map.merge!(
            javascript_lines: javascript_lines(@process_map[:file].content_lines),
            require_lines: require_lines(@process_map[:file].content_lines),
            output_dir: server_code_output_dir,
            output_file_path: @process_map[:file].file_path_for_dir( server_code_output_dir, @process_map[:file].ext ),
            reason: :server_code
        )

        out_ext_first = @process_map[:file].ext.split('.')[0]
        if out_ext_first == 'js' and  @process_map[:javascript_lines].length > 0
          @process_map.exceptions ||= []
          @process_map.exceptions << "javascript_lines are not possible in ServerRb (.js.opal.rb) files"
        end

      end
    end
end