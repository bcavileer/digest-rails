#!/usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'
require 'fileutils'
require 'open3'
require 'serviewer/engine.rb'

module Serviewer

  module ProcessCodeFile
    def process_file
      process_raw_file
      javascript_lines
      init_dependancies
    end
  end


  ## For File
  module OutputTemplate
    def write_output_file
      p "  Writing Template to #{output_path}"
      FileUtils::mkdir_p File.dirname(output_path)

      File.open(output_path,'w') do |f|
        content_lines.each do |l|
          f.puts l
        end
      end
    end

    private

    def output_path
      File.join(fileset_class.output_subdir,@library_name,@template_dir,output_filename)
    end

    def output_filename
      [@name,fileset_class.output_template_ext].join('.')
    end

  end

  ## For File
  module ProcessTemplateFile
    def process_template
      process_raw_file
      write_output_file
    end
  end

  ## For File
  module SourceTemplate

    def self.included(base)
      base.send :include, ProcessTemplateFile
      base.send :include, OutputTemplate
    end

  end

  ## For File
  module  SourceCode
    def self.included(base)
      base.send :include, GetJavascriptLines
      base.send :include, Dependancies
      base.send :include, AltLibrary
      base.send :include, ProcessCodeFile
    end
  end

  class SourceTemplateFile < SourceFile
    include SourceTemplate
  end

  class SourceCodeFile < SourceFile
    include SourceCode
  end

  #######################################################
  # All Files
  #######################################################

  ## For Server File Set
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

  ## For File Set
  module DependancySchedule

    def files_by_schedule
      files.sort do |x,y|
        xdo = x.dependancy_order ? x.dependancy_order : 0
        ydo = y.dependancy_order ? y.dependancy_order : 0
        xdo <=> ydo
      end
    end

    def map_dependancies
      p "Mapping Dependancies..."
      files.each do |file|
        file.map_dependancies(files_hash)
      end
    end

    def schedule_dependancies
      p "Scheduling Dependancies..."
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

  ## For File Set
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

  ## For File Set
  module ProcessCodeFiles

    def process_files
      print_seperator_1
      process_code_file_description
      print_seperator_2

      p "Removing old files..."
      FileUtils.remove_dir(self.code_output_subdir,true)
      print_seperator_2

      p "Processing Code Files..."
      files.each do |file|
        file.process
      end

      map_dependancies
      schedule_dependancies

      p "Report all..."
      report_all

      write_code_files

      #p "Run Thru Ruby..."
      #run_thru_ruby
      print_seperator_2
    end

  end

  ## For File Set
  module OutputClientCode
    def report_all
    end
  end

  ## For File Set
  module OutputServerCode

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

  ## For File Set
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

  ## For File Set
  module ServerOrClient
    def root_dir
      if rails_config_init_file_path
        File.join( File.dirname(rails_config_init_file_path), '..','..')
      else
        File.join(File.dirname(__FILE__),'..')
      end
    end
  end

  ## For File Set
  module Server

    def self.included(base)
      base.send :include, SourceFiles
      base.send :include, Dependancies
      base.send :include, DependancySchedule
      base.send :include, ProcessCodeFiles
      base.send :include, RunThruRuby
      base.send :include, OutputServerCode
    end

    def process_code_file_description
      p "Running #{self.class} to create single server code file in: #{self.code_output_path}"
    end

    def output_template_ext
      'erb'
    end

    def code_output_path
      File.join(code_output_subdir,output_filename)
    end

    private

    def write_code_files
      p "Writing Server code file..."
      write_code_file
    end

    def write_code_file
      p code_output_path
      FileUtils::mkdir_p File.dirname(code_output_path)
      File.open(code_output_path,'w') do |f|
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

  end

  ## For File Set
  module Client

    def self.included(base)
      base.send :include, OutputClientCode
    end

    def process_code_file_description
      p "Running #{self.class} to create code file tree under: #{code_output_subdir}"
    end

    def map_dependancies
    end

    def schedule_dependancies
    end


    def code_output_path(file)
      File.join(code_output_subdir,file.filename)
    end

    def output_template_ext
      'opalerb'
    end

    def write_code_files
      files.each do |file|
        p "Writing Client code file #{code_output_path(file)}..."
        FileUtils::mkdir_p File.dirname(code_output_path(file))
        File.open(code_output_path(file),'w') do |f|
          file.content_lines.each do |l|
            f.puts l
          end
        end

        #p code_output_path(file)
        #write_code_file(file)
        p
      end

    end

    def write_code_file(file)
      p code_output_path(file)
      #FileUtils::mkdir_p File.dirname(code_output_path)
      #File.open(code_output_path,'w') do |f|
      #  content_lines.each do |l|
      #    f.puts l
      #  end
      #end
    end

  end

  ############################

  ## For File Set
  module CodeOrTemplates

    def all_library_types
      %w{ poly_lib opal_lib ruby_lib js_lib  views_lib }.map{ |n| t = LibraryType.new; t.name = n; t }
    end

    def all_extensions
      %w{ rb js.opal js.opalerb js js.es6 html.opalerb }.map{ |n| e = Extension.new; e.name = n; e }
    end

    def get_library_types(type_names)
      all_library_types.select do |library_type|
        @library_type_names.include? library_type.name
      end
    end

    def get_extensions(extension_names)
      extension_names
      all_extensions.select do |extension|
        @extension_names.include? extension.name
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

  ## For File Set
  module Code

    def self.included(base)
      base.send :include, ProcessCodeFiles
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

    def glob_search(load_path)
      File.join( glob_search_base(load_path), library_type_search, '**', extension_search )
    end

  end

  module Templates

    def self.included(base)
      base.send :include, ProcessTemplateFiles
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
      get_extensions( %w{ js.opalerb html.opalerb } )
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

  class Base
    attr_accessor :rails_config_init_file_path

    def initialize(c)
      @rails_config_init_file_path = c[:rails_config_init_file_path]
    end

  end

  ############################

  class ServerCode < Base
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

    def initialize(c)
      super
      @library_type_names = %w{ poly_lib ruby_lib }
      @extension_names = %w{ rb js.opal }
    end

    def code_output_subdir
      File.join(output_dir,'code')
    end

  end

  class ServerTemplates < Base
    include All
    include ServerOrClient
    include Server
    include CodeOrTemplates
    include Templates

    def initialize(c)
      super
      @library_type_names = %w{ views_lib }
      @extension_names = %w{ js.opalerb html.opalerb }
    end

  end

  ############################

  class ClientCodeJs < Base
    include All
    include ServerOrClient
    include Client
    include CodeOrTemplates
    include Code

    def initialize(c)
      super
      @library_type_names = %w{ js_lib }
      @extension_names = %w{ js.es6 }
    end

    def output_filname
      'index.js.opal'
    end

    def code_output_subdir
      File.join(output_dir,'js_code')
    end

  end

  class ClientCodeOpal < Base
    include All
    include ServerOrClient
    include Client
    include CodeOrTemplates
    include Code

    def initialize(c)
      super
      @library_type_names = %w{ poly_lib opal_lib }
      @extension_names = %w{ js.opal }
    end

    def output_filname
      'index.js.opal'
    end

    def code_output_subdir
      File.join(output_dir,'opal_code')
    end

  end

  class ClientTemplates < Base
    include All
    include ServerOrClient
    include Client
    include CodeOrTemplates
    include Templates

    def initialize(c)
      super
      @library_type_names =  %w{ views_lib }
      @extension_names = %w{ js.opalerb }
    end

    def output_filname
      'index.js.opal'
    end

  end

end

