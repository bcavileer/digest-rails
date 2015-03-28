require 'serviewer/file/get_es6_exports_imports'
require 'serviewer/file/get_rb_requires'
require 'serviewer/file/output_dirs'

require 'serviewer/outputs/client_opal_code'
require 'serviewer/outputs/client_js_code'
require 'serviewer/outputs/client_template'
require 'serviewer/outputs/server_rb_code'
require 'serviewer/outputs/server_template'

require 'serviewer/processes/write_file'
require 'serviewer/processes/copy_file'
require 'serviewer/processes/javascript_lines'
require 'serviewer/processes/parse_and_sort_js_es6_on_imports'
require 'serviewer/processes/parse_and_sort_rb_on_requires'

require 'serviewer/processes/javascript_lines'
require 'serviewer/processes/require_lines'

require 'serviewer/file/gem_bundler'
require 'serviewer/file/source_files'
require 'serviewer/file/source_file'

module Serviewer

  class Builder

    include GemBundler

    include ClientOpalCode
    include ClientJsCode
    include ClientTemplate
    include ServerTemplate
    include ServerRbCode
    include CopyFile
    include WriteFile
    include OutputDirs

    include JavascriptLines
    include RequireLines

    attr_accessor :rails_config_init_file_path

    LIBRARY_NAMES = %w{ s_views s_lib s_controllers s_models }
    EXTENSIONS = %w{ rb js.opal js.opalerb js js.es6 html.opalerb }

    def initialize(c)
      @dry_run = c[:dry_run]
      @dry_run ||= true
      @log = true
      @rails_config_init_file_path = c[:rails_config_init_file_path]
      gem_bundler

      raise "requires rails_config_init_file_path" if @rails_config_init_file_path.nil?
    end

    def run
      cache_files
      process_files
      #output_files
      return true
    end

    def cache_files

      p "Caching Files"
      @cached_files = SourceFiles.new(
          serviewer_builder: self,
          library_list: LIBRARY_NAMES,
          extension_list: EXTENSIONS
      ).all.map do |file_path|
        path_s = file_path.split('/')
        LIBRARY_NAMES.map do |library_name|
          library_name_position = path_s.index(library_name)
          if library_name_position
            SourceFile.new(
                serviewer_builder: self,
                file_path: file_path,
                library_name: library_name,
                library_name_position: library_name_position
            )
          end
        end
      end.flatten.compact
    end

    def processes
      [
        :client_opal_code,
        :client_js_code,
        :client_template,
        :server_template,
        :server_code
      ]

    end

    def process_file(process,file)
      @process_map = {
          file: file
      }
      self.send(process)
      @process_maps << @process_map.clone
    end

    def process_files
      p "Processing Files"
      @process_maps = []
      @cached_files.map do |file|
        processes.map do |process|
          process_file(process,file)
        end
      end
    end

  end
end
