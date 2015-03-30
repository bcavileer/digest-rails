module Serviewer

  class SourceFiles
    include Lexical
    
    attr_reader :extension_list, :library_list

    def initialize(c)
      @serviewer_builder = c[:serviewer_builder]
      @library_list = c[:library_list]
      @extension_list = c[:extension_list]
    end

    def all
      p "Get Bundled Serviewer Libs:"

      p remove_quotes("Searching for libraries: #{library_list}")
      p remove_quotes("Searching for extensions: #{extension_list}")

      list = $LOAD_PATH.map do |load_path|
        load_path
        s = glob_search(load_path)
        r = Dir.glob(s)
        r
      end

      return list.flatten.uniq
    end

    def glob_search(load_path)
      File.join( load_path, '**', library_type_search, '**', extension_search )
    end

    def extension_search
      "*.{#{extension_list.join(',')}}"
    end

    def library_type_search
      "{#{library_list.join(',')}}"
    end

  end

end