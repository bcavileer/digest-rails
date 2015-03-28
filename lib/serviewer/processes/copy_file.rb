module Serviewer
  module CopyFile

    def copy_file
      @process_map[:content_lines] = @process_map[:file].content_lines
      write_file
    end

  end
end