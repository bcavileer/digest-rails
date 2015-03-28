module Serviewer
  class SourceFile
    include GetRbRequires
    include GetEs6ExportsImports

    attr_accessor :file_path, :library_type, :gem, :key, :name, :ext

    def initialize(c)
      @serviewer_builder = c[:serviewer_builder]
      @file_path = c[:file_path]
      @library_type = c[:library_name]
      @library_name_position = c[:library_name_position]

      file_path_s = file_path.split('/')

      last = file_path_s.last
      last_s = last.split('.')

      @gem_name = gem_cross_ref(file_path_s)
      @gem_name ||= 'application'

      @name = last_s[0]
      @ext = last_s[1..-1].join('.')
      @key = [ file_path_s[@library_name_position+1..-2], @name ].flatten.join('/')
    end

    def description
      "key:#{key} name: #{name}, gem: #{gem}, ext: #{ext}, file_path: #{file_path}"
    end

    def gem_cross_ref(file_path_s)
      @serviewer_builder.gem_hash.keys.map do |gem_name|
        file_path_s.select do |dir|
          gem_name == dir
        end
      end.flatten.compact
    end

    def name_ext
      [ @name, @ext].join('.')
    end

    def key_wo_last
      key.split('/')[0..-2].join('/')
    end

    def file_path_for_dir(dir,ext)
      last = [@name,ext].join('.')
      File.join( dir, @gem_name, key_wo_last, last )
    end

    def content
      File.open(@file_path).read
    end

    def content_lines
      content.split("\n")
    end

  end
end
