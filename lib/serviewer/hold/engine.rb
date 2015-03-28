class Engine

  class SourceFile
    include AnySourceFile
    attr_accessor :fileset_class
    attr_accessor :extension, :library_name, :library_type, :path, :key

    def filename
      "#{key}.#{extension.name}"
    end

  end

  def initialize

  end

  def self.config(c)
    yield c
  end
end