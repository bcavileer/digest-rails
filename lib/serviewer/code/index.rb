#
# From File: views/poly_lib/context_hash Order: 1
#
require('ostruct')

class ContextHash

    def self.create(hash)
        n = self.new
        return n.create(hash)
    end

    def create(hash)
       return OpenStruct.new(
        recursed(hash)
       )
    end

    def recursed(hash)
        hash.keys.inject({}) do |h,k|
            v = hash[k]
            h[k] = if v.is_a? Hash
                ContextHash.create(v)
            else
                v
            end
            h
        end
    end

end
#
# From File: views/ruby_lib/vlogger Order: 1
#
class VLogger

    def log(text,object=nil)
        if object.nil?
            puts text
        else
            puts "#{text} #{object}"
        end
    end

end
#
# From File: views/ruby_lib/template_opal Order: 1
#
require('erb')

class Template
  @_cache = {}

  class Init
    def dir
      File.dirname(__FILE__)
    end

    def local_glob_string
      File.expand_path(
        File.join(dir,'../templates','**','*.erb')
      )
    end

    def template_filenames(glob_string)
      glob_string ||= local_glob_string
      Dir.glob(glob_string)
    end

    def template_path(template_filename)
      fp_s = template_filename.split('/')
      n_s = fp_s.last.split('.')
      [ 'templates',fp_s[-3], fp_s[-2], n_s[0] ].flatten.join('/')
    end

    def erb_object(template_filename)
      erb = ERB.new(File.open(template_filename).read)
      erb.filename = template_filename
      return erb
    end

    def cache_all(glob_string)
      template_filenames(glob_string).each do |template_filename|
        Template.new(
              template_path(template_filename),
              erb_object(template_filename)
        )
      end
    end

    def self.cache(glob_string=nil)
      self.new.cache_all(glob_string)
    end

  end

  def self.[](name)
    @_cache[name] || @_cache["templates/#{name}"]
  end

  def self.[]=(name, instance)
    @_cache[name] = instance
  end

  def self.paths
    @_cache.keys
  end

  def initialize(name, erb)
    @name, @erb = name, erb
    Template[name] = self
  end

  def inspect
    "#<Template: '#@name'>"
  end

  def dehashify
    if @context.is_a? Hash
      @context = ContextHash.create(@context)
    end
  end

  def render(context)
    @context = context
    dehashify
    @context.define_singleton_method(:get_binding) do
      return binding
    end
    @erb.result(@context.get_binding)
  end

end
#
# From File: views/poly_lib/template_opal Order: 2
#
# Include the OPAL library Template code OR it's RUBY equivalent
# Processed Require Line: require 'digest-rails/poly_lib/context_hash'
# Processed Require Line: require 'digest-rails/opal_lib/template'
