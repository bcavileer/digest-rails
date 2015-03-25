#!/usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'
require 'tempfile'
require 'open3'

############################
# Each File
############################

class Extension
  attr_accessor :name

  def description
    "Extension #{name} "
  end

end

class LibraryType
  attr_accessor :name

  def description
    "LibraryType #{name} "
  end

end

module GetJavascriptLines

  def javascript_lines
      return @javascript_lines if @javascript_lines

      line_number = 1

      @javascript_lines = content_lines.map do |line|
        r = if /\`/ =~ line
          r = {
              line_number: line_number,
              line: line
          }
          r
        else
          nil
        end

        line_number += 1
        r
      end.compact

  end

  def report_javascript_lines
    return if javascript_lines.length == 0
    p description
    javascript_lines.each do |l|
      p "  #{l[:line_number]} : #{l[:line].strip}"
    end
    p " "
  end

end

module AltLibrary

  def use_key(k,alt_library)

    dependancy_library_type = k.split('/')[1].to_sym
    dependancy_name = k.split('/')[2].to_sym

    if alt_library.keys.include?(dependancy_library_type)
      calc_key(alt_library[dependancy_library_type][:library_type],dependancy_name)
    else
      calc_key(dependancy_library_type,dependancy_name)
    end

  end

  def map_alt_library(k,file_hash,alt_library)
    ek = use_key(k,alt_library)
    file_hash[ ek ]
  end

end

module Dependancies
  attr_accessor :dependancy_order, :dependancy_map

  def init_dependancies
    @dependancy_order = nil
    dependancy_map
  end

  def to_key(require_ref)
    require_ref.gsub("\"",'').gsub("\'",'')
  end

  def dependancy_map
    @dependancy_map ||= content_lines.inject({}) do |hr,line|
        tokens = line.strip.split(' ').map{ |token| token.strip }
        if tokens[0] == 'require'
          rkey = to_key( tokens[1] )
          hr[ rkey ] = nil #@poly_lib[tokens[1]]
        end
        hr
    end
  end

  def map_dependancies(file_hash,alt_library)
    dependancy_map.keys.each do |k|
      dependancy_map[k] = map_alt_library(k,file_hash,alt_library)
    end
  end

  def unscheduled_at_last_iteration(dependancy,this_iteration)
    dependancy.dependancy_order.nil? or dependancy.dependancy_order == this_iteration
  end

  def unscheduled_dependancies_at_last_iteration( this_iteration )
    dependancy_map.values.inject([]) do |a,dependancy|
      if dependancy and unscheduled_at_last_iteration(dependancy, this_iteration)
        a << dependancy
      end
      a
    end
  end

  def report_dependancy_mapped_to_nil
    any = false
    dependancy_map.keys.each do |k|
      if dependancy_map[k].nil?
        if !any
          p description
          any = true
        end
        p "    dependancy #{k} not mapped"
        p " "
      end
    end
  end

  def report_dependancy_order_nil
    if self.dependancy_order.nil?
      p description
      p "    dependancy_order is nil"
      self.dependancy_map.each_pair do |key,mapped_to|
        p "      #{key} => #{mapped_to ? mapped_to.key : 'NIL'}  #{mapped_to ? mapped_to.dependancy_order : ''} "
      end
      p " "
    end
  end

end

module ProcessFile
  attr_accessor :possible_library_types

  def calc_key(library_type,name)
    [ @library_name,library_type,name ].flatten.join('/')
  end

  def process_raw_file
    source_path_split = path.split('/')
    name_split = source_path_split.last.split('.')
    @name = name_split[0]
    @library_name = source_path_split[-3]
    @library_type = source_path_split[-2]
    @extension = Extension.new
    @extension.name = name_split[1..-1].join('.')
    @key = calc_key(@library_type,@name)

    @library_type = possible_library_types.select do |library_type|
      source_path_split.include? library_type.name
    end.first
  end

  def process_file
    process_raw_file
    javascript_lines
    init_dependancies
  end

end

class SourceFile

  attr_accessor :extension, :library_name, :library_type, :path, :key

  include GetJavascriptLines
  include Dependancies
  include AltLibrary
  include ProcessFile

  def process
    process_file
    init_dependancies
  end

  def description
    "SourceFile #{library_name} #{library_type.name} #{@name}.#{extension.name}"
  end

  def content
    @content ||= File.open(@path).read
  end

  def content_lines
    @content_lines ||= content.split("\n")
  end

end

############################
# All Files
############################

module SourceFiles
  attr_reader :extensions, :library_types, :files

  def files
    @files ||= get_files
  end

  def get_files
    get_raw_files.map do |raw_file|
      sf = SourceFile.new
      sf.possible_library_types = library_types
      sf.path = raw_file
      sf
    end
  end

  def get_raw_files
    p "Get Bundled Serviewer Libs:"
    bundler
    local_path
    list = $LOAD_PATH.map do |load_path|
      s = glob_search(load_path)
      rs = Dir.glob( s )
    end
    return list.flatten.uniq
  end

  def bundler
    @bundler ||= Bundler.setup(:default)
  end

  def local_path
    @local_path ||= $LOAD_PATH.unshift File.expand_path('../../', __FILE__)
  end

  def glob_search(load_path)
    library_type_search
    extension_search
    @glob_string ||= File.join( load_path, '**', 'assets', 'javascripts', '**', library_type_search, extension_search )
  end

  def extension_search
    "*.{#{@extensions.map{|e| e.name}.join(',')}}"
  end

  def library_type_search
    "{#{@library_types.map{|t| t.name}.join(',')}}"
  end

end

module RunThruRuby

  def run_thru_ruby
    write_rb_file
    run_ruby
  end

  def run_ruby
    stdin, stdout, stderr, wait_thr = Open3.popen3(ruby_command)
    @ruby_stdout = stdout.gets(nil)
    @ruby_stderr = stderr.gets(nil)
    if ( @ruby_exit_code = wait_thr.value ) != 0
      p "Run Thru Ruby failed: #{description}"
      p @ruby_stdout
      p @ruby_stderr
      @ruby_passed = false
    else
      @ruby_passed = true
    end

    stdout.close
    stderr.close
  end

  def rb_path_name
    self.class.underscore
  end

  def create_rb_file
    @rb_file = Tempfile.new(rb_path_name)
  end

  def rb_file_path
    @rb_file.path
  end

  def write_rb_file
    create_rb_file
    File.open(rb_file_path,'w') do |file|
      @content_lines.each do |line|
        file.puts line
      end
    end
  end

  def ruby_command
    @ruby_command ||= "ruby --verbose  #{rb_file_path}"
  end

end

module DependancySchedule

  def files_by_schedule
    files.sort do |x,y|
      xdo = x.dependancy_order ? x.dependancy_order : 0
      ydo = y.dependancy_order ? y.dependancy_order : 0
      xdo <=> ydo
    end
  end

  def schedule_dependancies
    (1 .. files.length).each do |iteration|
      scheduled = schedule_dependancy_iteration(iteration)
      p scheduled.length
      break if scheduled.length == 0
    end
  end

  def schedule_dependancy_iteration(iteration)
    files.map do |file|
      schedule_file_dependancy_iteration(file,iteration)
    end.compact
  end

  def schedule_file_dependancy_iteration(file,iteration)
    if file.dependancy_order.nil? and file.unscheduled_dependancies_at_last_iteration(iteration).length == 0
      schedule_file_dependancy(file,iteration)
    else
      nil
    end
  end

  def schedule_file_dependancy(file,iteration)
    file.dependancy_order = iteration
    return file
  end

end

module ProcessFiles
  def process_files

    p "Processing Files..."
    files.each do |file|
      file.process
    end

    p "Mapping Dependancies..."
    files.each do |file|
      file.map_dependancies(files_hash,alt_library)
    end

    p "Scheduling Dependancies..."
    schedule_dependancies

    p "Report all..."
    report_all

  end

  def files_hash
    @files_hash ||= files.inject({}) do |h,file|
      h[file.key] = file
      h
    end
  end

end

module Output
  attr_accessor :content_lines

  def report_all

    p "  report_dependancy_mapped_to_nil"
    p " "
    files.each{ |file| file.report_dependancy_mapped_to_nil }

    p "  report_javascript_lines:"
    p " "
    files.each{ |file| file.report_javascript_lines }

    p "  report_dependancy_order_nil:"
    p " "
    files.each{ |file| file.report_dependancy_order_nil }
    p " "

    p "  files_by_schedule:"
    p " "

    files_by_schedule.each do |f|
       p "order: #{f.dependancy_order} => #{f.description}"
    end

  end

  def concat_all
    #files_by_schedule.each do |f|
      #if h[:js_lines].length == 0
      #  File.open(h[:target_path],'w') do |f|
      #    h[:source_lines].each do |line|
      #      f.puts line
      #    end
      #  end
      #end
    #end
  end
end

############################

class Serviewer
  include SourceFiles
  include DependancySchedule
  include ProcessFiles
  include RunThruRuby
  include Output

  def initialize
    @all_library_types = %w{ poly_lib opal_lib ruby_lib js_lib }.map{ |n| t = LibraryType.new; t.name = n; t }
    @all_extensions = %w{ rb js.opal js.opalerb js }.map{ |n| e = Extension.new; e.name = n; e }
  end

  def get_library_types(type_names)
    @library_types = @all_library_types.select do |library_type|
      type_names.include? library_type.name
    end
  end

  def get_extensions(extension_names)
    extension_names
    @extensions = @all_extensions.select do |extension|
      extension_names.include? extension.name
    end
  end

end

class ServiewerServer < Serviewer

  def initialize
    super
    get_library_types( %w{ poly_lib ruby_lib } )
    get_extensions( %w{ rb js.opal js.opalerb } )
  end

  def alt_library
    { :opal_lib => { library_type: :ruby_lib, extension: '.rb' } }
  end

end

#class ServiewerClient < Serviewer
#  include SourceFiles
#  include DependancySchedule

#  def initialize
#    super
#    get_library_types( %w{ poly_lib opal_lib js_lib } )
#    get_extensions( %w{ rb js.opal js.opalerb js } )
#  end
#end

ServiewerServer.new.process_files

