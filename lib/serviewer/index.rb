#
# From File: views/poly_lib/template_wrap Order: 1
#
# Processed Require Line: require 'digest-rails/opal_lib/template'

class TemplateWrap
end
#
# From File: views/ruby_lib/template_wrap Order: 1
#
class Template
  @_cache = {}
  def self.[](name)
    @_cache[name] || @_cache["templates/#{name}"]
  end

  def self.[]=(name, instance)
    @_cache[name] = instance
  end

  def self.paths
    @_cache.keys
  end

  attr_reader :body

  def initialize(name, &body)
    @name, @body = name, body
    Template[name] = self
  end

  def inspect
    "#<Template: '#@name'>"
  end

  def render(ctx = self)
    ctx.instance_exec(OutputBuffer.new, &@body)
  end

  class OutputBuffer
    def initialize
      @buffer = []
    end

    def append(str)
      @buffer << str
    end

    alias append= append

    def join
      @buffer.join
    end
  end
end

dir = File.dirname(__FILE__)
glob_string = File.join(dir,'*.erb')
Dir.glob(glob_string).each do |erb_file_path|
  erb_file_path_s = erb_file_path.split('/')
  erb_name_s = erb_file_path_s.last.split('.')
  name = [ erb_file_path_s[-2], erb_name_s[0] ].join('/')
  Template.new(name)
end
p Template.paths
