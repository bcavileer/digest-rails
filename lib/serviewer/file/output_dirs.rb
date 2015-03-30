module Serviewer
  module OutputDirs

    def root_ref(path)
      path_s = path.split('/')
      "ROOT:#{path_s[root_dir_length..-1].join('/') }"
    end

    def client_template_output_dir
      File.join(client_output_dir,'template')
    end

    def client_opal_code_output_dir
      client_code_output_dir
    end

    def client_js_code_output_dir
      client_code_output_dir
    end

    def server_template_output_dir
      File.join(server_output_dir,'template')
    end

    private

    def client_code_output_dir
      File.join(client_output_dir,'code')
    end

    def client_output_dir
      File.expand_path(
          File.join(root_dir,'app/assets/javascripts/serviewer')
      )
    end

    def server_code_output_dir
      File.join(server_output_dir,'code')
    end

    def server_output_dir
      File.expand_path(
          File.join(root_dir,'lib/serviewer')
      )
    end

    def root_dir_length
      @root_dir_length = root_dir.split('/').length
    end

    def root_dir
      if rails_config_init_file_path
        File.expand_path(
            File.join( File.dirname(@rails_config_init_file_path), '..','..')
        )
      else
        p File.dirname(__FILE__)
        File.join(File.dirname(__FILE__),'..')
      end
    end

  end
end