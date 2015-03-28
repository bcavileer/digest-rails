module Serviewer

  ## For File Set
  class SourceFiles
    attr_reader :extension_list, :library_list

    def initialize(c)
      @library_list = c[:library_list]
      @extension_list = c[:extension_list]
    end

    def all
      p "Get Bundled Serviewer Libs:"

      p "Searching for libraries: #{library_list}"
      p "Searching for extensions: #{extension_list}"

      bundler
      local_path

      list = $LOAD_PATH.map do |load_path|
        load_path
        s = glob_search(load_path)
        r = Dir.glob(s)
        r
      end

      return list.flatten.uniq
    end

    def glob_search(load_path)
      File.join(load_path,'**',library_type_search,'**',extension_search)
    end

    def bundler
      @bundler ||= Bundler.setup(:default)
    end

    def local_path
      @local_path ||= $LOAD_PATH.unshift File.expand_path('../../../..', __FILE__)
    end

    def extension_search
      "*.{#{extension_list.join(',')}}"
    end

    def library_type_search
      "{#{library_list.join(',')}}"
    end
  end

end