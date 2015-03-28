module Serviewer
  class SourceFile
    include GetRbRequires
    include GetEs6ExportsImports

    attr_accessor :file_path, :library_type, :gem, :key, :name, :ext

    def initialize(file_path,library_name,library_name_position)
      @file_path = file_path
      @library_type = library_name

      file_path_s = file_path.split('/')

      @gem = if app_position = file_path_s.index('app')
        file_path_s[app_position-1]
      elsif lib_position = file_path_s.index('lib')
        file_path_s[lib_position-1]
      end

      last = file_path_s.last
      last_s = last.split('.')

      @name = last_s[0]
      @ext = last_s[1..-1].join('.')
      @key = [ file_path_s[library_name_position+1..-2], @name ].flatten.join('/')
    end

    def description
      "key:#{key} name: #{name}, gem: #{gem}, ext: #{ext}, file_path: #{file_path}"
    end

    def name_ext
      [ @name, @ext].join('.')
    end

    def key_wo_last
      key.split('/')[0..-2].join('/')
    end

    def file_path_for_dir(dir,ext)
      last = [@name,ext].join('.')
      File.join( dir, gem, key_wo_last, last )
    end

    def content
      File.open(@file_path).read
    end

    def content_lines
      content.split("\n")
    end

  end
end
