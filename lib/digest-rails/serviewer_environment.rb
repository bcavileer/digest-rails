#!/usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'
require 'fileutils'
require 'open3'

module Serviewer


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

    def use_key(k)
      dependancy_library_type = k.split('/')[1].to_sym
      dependancy_name = k.split('/')[2].to_sym

      if fileset_class.alt_library.keys.include?(dependancy_library_type)
        calc_key(fileset_class.alt_library[dependancy_library_type][:library_type],dependancy_name)
      else
        calc_key(dependancy_library_type,dependancy_name)
      end

    end

    def map_alt_library(k,file_hash)
      ek = use_key(k)
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
        if require = require_from_line(line)
          hr[ require[:rkey] ] = nil
        end
        hr
      end
    end

    def require_from_line(line)
      tokens = line.strip.split(' ').map{ |token| token.strip }
      if tokens[0] == 'require'
        {
            rkey: to_key( tokens[1] ),
            line: line
        }
      else
        nil
      end
    end

    def map_dependancies(file_hash)
      dependancy_map.keys.each do |k|
        dependancy_map[k] = map_alt_library(k,file_hash)
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

  module ProcessCodeFile

    def process_file
      process_raw_file
      javascript_lines
      init_dependancies
    end

  end

  module AnySourceFile
    attr_accessor :fileset_class

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

    def calc_key(library_type,name)
      [ @library_name,library_type,name ].flatten.join('/')
    end

    def process_raw_file
      source_path_split = path.split('/')
      name_split = source_path_split.last.split('.')

      @name = name_split[0]
      fileset_class.path_labels(source_path_split).each_pair do |k,v|
        instance_variable_set("@#{k}",v)
      end

      @extension = Extension.new
      @extension.name = name_split[1..-1].join('.')
      @key = calc_key(@library_type,@name)

      @library_type = fileset_class.library_types.select do |library_type|
        source_path_split.include? library_type.name
      end.first
      return self
    end

  end

  module ProcessTemplateFile
    def output_path
      File.join(fileset_class.output_subdir,@library_name,@template_dir,output_filename)
    end

    def output_filename
      [@name,fileset_class.output_template_ext].join('.')
    end

    def write_output_file
      p "  Writing Template to #{output_path}"
      FileUtils::mkdir_p File.dirname(output_path)

      File.open(output_path,'w') do |f|
        content_lines.each do |l|
          f.puts l
        end
      end
    end

    def process_template
      process_raw_file
      write_output_file
    end
  end

  class SourceTemplateFile
    include AnySourceFile
    include ProcessTemplateFile
    attr_accessor :extension, :library_name, :library_type, :path, :key
  end

  class SourceCodeFile
    include AnySourceFile
    attr_accessor :extension, :library_name, :library_type, :path, :key

    include GetJavascriptLines
    include Dependancies
    include AltLibrary
    include ProcessCodeFile

  end

  ############################
  # All Files
  ############################

  module SourceFiles
    attr_reader :extensions, :library_types, :files

    def files
      @files ||= get_files
    end

    def files_hash
      @files_hash ||= files.inject({}) do |h,file|
        h[file.key] = file
        h
      end
    end

    def get_files
      get_raw_files.map do |raw_file|
        sf = new_source_file
        sf.fileset_class = self
        sf.path = raw_file
        sf
      end
    end

    def get_raw_files
      p "Get Bundled Serviewer Libs:"
      p "Searching for library types: #{library_type_search}"
      p "Searching for extensions: #{extension_search}"
      bundler
      local_path
      list = $LOAD_PATH.map do |load_path|
        load_path
        s = glob_search(load_path)
        r = Dir.glob( s )
        r
      end
      return list.flatten.uniq
    end

    def bundler
      @bundler ||= Bundler.setup(:default)
    end

    def local_path
      @local_path ||= $LOAD_PATH.unshift File.expand_path('../../', __FILE__)
    end

    def extension_search
      "*.{#{extensions.map{|e| e.name}.join(',')}}"
    end

    def library_type_search
      "{#{library_types.map{|t| t.name}.join(',')}}"
    end

  end

  module RunThruRuby

    def run_thru_ruby
      run_ruby
    end

    def run_ruby
      stdin, stdout, stderr, wait_thr = Open3.popen3(ruby_command)
      @ruby_stdout = stdout.gets(nil)
      @ruby_stderr = stderr.gets(nil)
      if ( @ruby_exit_code = wait_thr.value ) != 0
        p "Run Thru Ruby failed"
        p @ruby_stdout
        p @ruby_stderr
        @ruby_passed = false
      else
        @ruby_passed = true
      end

      stdout.close
      stderr.close
    end

    def ruby_command
      @ruby_command ||= "ruby --verbose  #{output_path}"
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

  module ProcessTemplateFiles

    def process_files
      print_seperator_1

      p "Running #{self.class} to create templates in: #{self.output_subdir}"
      print_seperator_2

      p "Removing old files..."
      FileUtils.remove_dir(self.output_subdir,true)
      print_seperator_2

      p "Processing Template Files..."
      files.each do |file|
        file.process_template
      end
    end

  end

  module ProcessCodeFiles

    def process_files
      print_seperator_1
      p "Running #{self.class} to create file: #{self.output_path}"
      print_seperator_2

      p "Removing old files..."
      FileUtils.remove_dir(self.output_subdir,true)
      print_seperator_2

      p "Processing Code Files..."
      files.each do |file|
        file.process
      end

      p "Mapping Dependancies..."
      files.each do |file|
        file.map_dependancies(files_hash)
      end

      p "Scheduling Dependancies..."
      schedule_dependancies

      p "Report all..."
      report_all

      p "Write code file..."
      write_code_file

      #p "Run Thru Ruby..."
      #run_thru_ruby
    end

  end

  module OutputCode

    def report_all

      p "  report_dependancy_mapped_to_nil"
      p " "
      files.each{ |file| file.report_dependancy_mapped_to_nil }

      p "  report_javascript_lines:"
      print_seperator_2
      files.each{ |file| file.report_javascript_lines }

      p "  report_dependancy_order_nil:"
      print_seperator_2
      files.each{ |file| file.report_dependancy_order_nil }
      print_seperator_2

      p "  files_by_schedule:"
      print_seperator_2

      files_by_schedule.each do |f|
         p "order: #{f.dependancy_order} => #{f.description}"
      end

    end

  end

  module OutputTemplates

  end

  module All

    def self.included(base)
      base.send :include, SourceFiles
    end

    def print_seperator_1
      p " "
      p "-----------------------------------"
      p " "
    end

    def print_seperator_2
      p " "
    end

    def alt_library
      {}
    end

  end
  ############################

  module ServerOrClient
  end

  module Server

    def self.included(base)
      base.send :include, SourceFiles
      base.send :include, Dependancies
      base.send :include, DependancySchedule
      base.send :include, ProcessCodeFiles
      base.send :include, RunThruRuby
    end

    def root_dir
      if rails_config_init_file_path
        File.join(rails_config_init_file_path,'..','..')
      else
        File.join(File.dirname(__FILE__),'..')
      end
    end

    def output_dir
      File.expand_path(
          File.join(root_dir,'lib/serviewer')
      )
    end

    def output_template_ext
      'erb'
    end

  end

  module Client

    def output_dir
      File.expand_path(
          File.join(File.dirname(__FILE__),'..','app/assets/javascripts/serviewer')
      )
    end

    def output_template_ext
      'opalerb'
    end

  end

  ############################

  module CodeOrTemplates

    def all_library_types
      %w{ poly_lib opal_lib ruby_lib js_lib  views_lib }.map{ |n| t = LibraryType.new; t.name = n; t }
    end

    def all_extensions
      %w{ rb js.opal js.opalerb js js.es6 }.map{ |n| e = Extension.new; e.name = n; e }
    end

    def get_library_types(type_names)
      all_library_types.select do |library_type|
        type_names.include? library_type.name
      end
    end

    def get_extensions(extension_names)
      extension_names
      all_extensions.select do |extension|
        extension_names.include? extension.name
      end
    end

    def source_file_new
      SourceTemplateFile.new
    end

    def glob_search_base(load_path)
      File.expand_path(
          File.join( load_path, '..','**', 'app', 'views' )
      )
    end

  end

  module Code

    def self.included(base)
      base.send :include, ProcessCodeFiles
      base.send :include, OutputCode
    end

    def path_labels(source_path_split)
      {
        library_name: source_path_split[-3],
        library_type: source_path_split[-2]
      }
    end

    def library_types
      get_library_types( %w{ poly_lib ruby_lib } )
    end

    def extensions
      get_extensions( %w{ rb js.opal } )
    end

    def new_source_file
      SourceCodeFile.new
    end

    def output_subdir
      File.join(output_dir,'code')
    end

    def output_path
      File.join(output_subdir,output_filename)
    end

    def write_code_file
      p output_path
      FileUtils::mkdir_p File.dirname(output_path)
      File.open(output_path,'w') do |f|
        content_lines.each do |l|
          f.puts l
        end
      end
    end

    def content_lines
      @content_lines ||= files_by_schedule.map do |f|
        [
            "#",
            "# From File: #{f.key} Order: #{f.dependancy_order}",
            "#",
            f.content_lines.map do |l|
              if require = require_from_line(l)
                "# Processed Require Line: #{require[:line]}"
              else
                l
              end
            end
        ]
      end.flatten
    end

    def glob_search(load_path)
      File.join( glob_search_base(load_path), library_type_search, extension_search )
    end

  end

  module Templates

    def self.included(base)
      base.send :include, ProcessTemplateFiles
      base.send :include, OutputTemplates
    end

    def path_labels(source_path_split)
      {
        library_name: source_path_split[-6],
        template_dir: source_path_split[-2],
        library_type: source_path_split[-3]
      }

    end

    def library_types
      get_library_types( %w{ views_lib } )
    end

    def extensions
      get_extensions( %w{ js.opalerb } )
    end

    def output_subdir
      File.join(output_dir,'templates')
    end

    def new_source_file
      SourceTemplateFile.new
    end

    def glob_search(load_path)
      File.join( glob_search_base(load_path), library_type_search, '', '**' ,extension_search )
    end

  end

  ############################

  class ServiewerBase
    attr_accessor :rails_config_init_file_path

    def initialize(c)
      @rails_config_init_file_path = c[:rails_config_init_file_path]
    end
  end

  ############################

  class ServiewerServerCode < ServiewerBase
    include All
    include ServerOrClient
    include Server
    include CodeOrTemplates
    include Code

    def alt_library
      { :opal_lib => { library_type: :ruby_lib, extension: '.rb' } }
    end

    def output_filename
      'index.rb'
    end

  end
  #Serviewer::ServiewerServerCode.new.process_files


  class ServiewerServerTemplates < ServiewerBase
    include All
    include ServerOrClient
    include Server
    include CodeOrTemplates
    include Templates
  end
  #Serviewer::ServiewerServerTemplates.new.process_files

  ############################

  class ServiewerClientCode < ServiewerBase
    include All
    include ServerOrClient
    include Client
    include CodeOrTemplates
    include Code

    def initialize(c)
      super
      get_library_types( %w{ views_lib } )
      get_extensions( %w{ js.opalerb } )
    end

    def output_filname
      'index.js.opal'
    end

  end
  #ServiewerClientCode.new.process_files

  class ServiewerClientTemplates < ServiewerBase
    include All
    include ServerOrClient
    include Client
    include CodeOrTemplates
    include Templates

    def initialize(c)
      super
      get_library_types( %w{ poly_lib opal_lib js_lib } )
      get_extensions( %w{ rb js.opal js.opalerb } )
    end

    def output_filname
      'index.js.opal'
    end

  end
  #ServiewerClientTemplates.new.process_files

############################
end

#Serviewer::ServiewerServerTemplates.new.process_files
#Serviewer::ServiewerServerCode.new.process_files



