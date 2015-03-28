module Serviewer
  module WriteFile
    def write_file

      if @log
      end

      if !@dry_run
        FileUtils::mkdir_p File.dirname(@process_map[:output_file_path])
        if @process_map[:reason].nil?
          raise 'Cannot write without reason'
        end
        File.open(@process_map[:output_file_path],'w') do |outfile|
          @process_map[:content_lines].each do |line|
            outfile.puts line
          end
        end
      end

    end
  end
end