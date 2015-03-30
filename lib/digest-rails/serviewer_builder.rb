require 'serviewer/file/output_dirs'

require 'serviewer/outputs/client_opal_code'
require 'serviewer/outputs/client_js_code'
require 'serviewer/outputs/client_template'
require 'serviewer/outputs/server_rb_code'
require 'serviewer/outputs/server_template'

require 'serviewer/processes/write_file'
require 'serviewer/processes/copy_file'

require 'serviewer/processes/get_opal_javascript_lines'
require 'serviewer/processes/get_rb_require_lines'
require 'serviewer/processes/get_js_import_lines'
require 'serviewer/processes/get_js_export_lines'

require 'serviewer/file/gem_bundler'
require 'serviewer/file/lexical'
require 'serviewer/file/source_files'
require 'serviewer/file/source_file'

require 'serviewer/post_process/build_manifests'
require 'serviewer/post_process/exception'

module Serviewer

  class Builder
    include Exception

    include GemBundler

    include ClientOpalCode
    include ClientJsCode
    include ClientTemplate
    include ServerTemplate
    include ServerRbCode
    include CopyFile
    include WriteFile
    include OutputDirs

    include Lexical

    include GetOpalJavascriptLines
    include GetRbRequireLines
    include GetJsImportLines
    include GetJsExportLines

    include BuildManifests

    attr_accessor :rails_config_init_file_path

    LIBRARY_NAMES = %w{ s_views s_lib s_controllers s_models }
    EXTENSIONS = %w{ rb js.opal js.opalerb js js.es6 html.opalerb }

    def initialize(c)
      @dry_run = c[:dry_run]
      #@dry_run ||= true
      #@log = true
      @rails_config_init_file_path = c[:rails_config_init_file_path]
      gem_bundler

      raise "requires rails_config_init_file_path" if @rails_config_init_file_path.nil?
    end

    def run
      cache_files
      process_files
      build_manifests
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

    def check_for_existing(from_hash,ready_for_hash_process_map)
      if from_hash
        post_processs_exception(
          message: [
            "Contention for reason #{from_hash[:reason]}, key #{from_hash[:file].key} ....}",
            "Two files exist with the same keys... check extensions...",
            "Previously defined file #{from_hash[:file].file_path}",
            "Newly defined file #{ready_for_hash_process_map[:file].file_path}"
          ],
          process_maps: [ from_hash,ready_for_hash_process_map ]
        )
      end
    end

    def add_to_process_map_reason_hash
      @process_map_reason_hash ||= {}

      r = @process_map[:reason]
      if r.nil?
        raise "Process #{process} did not assign reason"
      end
      @process_map_reason_hash[r] ||= {}

      k = @process_map[:file].key
      if k.nil?
        raise "Process #{@process_map} did not assign key"
      end

      check_for_existing(@process_map_reason_hash[r][k],@process_map)
      @process_map_reason_hash[r][k] = @process_map.clone
      @process_map = nil
    end

    def process_file(process,file)
      @process_map = {
          file: file
      }
      self.send(process)

      return if @process_map.keys == [:file]
      add_to_process_map_reason_hash
    end

    def process_files
      p "Processing Files"
      @cached_files.map do |file|
        processes.map do |process|
          process_file(process,file)
        end
      end
    end

  end
end
