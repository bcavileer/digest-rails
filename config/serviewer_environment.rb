#!/usr/bin/env ruby

require 'fileutils'
require 'open3'

class ServiewerEnvironment
  PREFIX = "../app/assets/javascripts/"
  TARGET = "../app/assets/javascripts/temp_rb_lib"

  class <<self

    def purge_target
      target_dir = File.expand_path(TARGET)
      p "Purging #{target_dir}"
      FileUtils.rm_rf(target_dir)
    end

    def require
      purge_target
      n = self.new
      n.get_poly_lib
      n.get_requires

      n.get_javascript_lines
      n.copy_to_rb
      n.run_rb_thru_ruby
      n.dump_poly_lib
      n.sort_poly_lib_paths

      #n.create_temp_poly_lib_rb
    end
  end

  def dump_poly_lib

    p "Dump Poly Lib:"
    @poly_lib.values.each do |h|
      p "#{ h[:name]} : Length: #{h[:source_lines].length}"
      p requires_for(h)
      if h[:js_lines].length > 0
        h[:js_lines].each do |js_line|
          p "   #{ js_line[:line_number] } : #{ js_line[:line]} }"
        end
      end
    end
  end

  def initialize
  end

  def get_poly_lib_paths
    @poly_lib_file_paths = Dir.glob( File.expand_path( File.join(PREFIX,"/digest-rails/poly_lib/*.*") ) )
  end

  def get_poly_lib

    p "Get Poly Lib:"
    prefix_length = File.expand_path(PREFIX).split('/').length

    @poly_lib = get_poly_lib_paths.inject({}) do |h,source_path|
      source_path_split = source_path.split('/')
      path_split = source_path_split[prefix_length..-1]
      path = path_split.join('/')
      f_last_split = path_split.last.split('.')

      target_name = [f_last_split[0],'rb'].join('.')
      target_path = File.join(TARGET,path_split[0..-2],target_name)
      target_dir = File.dirname(target_path)

      FileUtils.mkpath target_dir
      key = to_key( File.join(path_split[0..-2],f_last_split[0]) )

      h[key] = {
          name: f_last_split[0],
          key: key,
          ext: f_last_split[1..-1].join('.'),
          path: path_split.join('/'),
          source_path: source_path,
          target_path: target_path,
          source_lines: File.read(source_path).split("\n")
      }
      h

    end

  end

  def to_key(path)
    path.gsub( "\/", "__" ).gsub( "\'", '' ).gsub( "\"", '' ).to_sym
  end

  def get_requires
    p "Get Requires:"
    @poly_lib.values.each do |h|
      h[:requires] = h[:source_lines].inject({}) do |hr,line|
        tokens = line.strip.split(' ').map{ |token| token.strip }
        if tokens[0] == 'require'
          rkey = to_key(tokens[1])
          hr[ rkey ] = nil #@poly_lib[tokens[1]]
        end
        hr
      end
    end

  end

  def requires_for(h,current_iteration=nil)
    all = h[:requires]

    unscheduled = all.keys.select do |k|
      linked = @poly_lib[k]
      if linked
        schedule = linked[:scheduled_compile_order]
        if schedule and current_iteration
          schedule == current_iteration
        else
          true
        end
      else
        p "in #{h[:path]}, require #{k} not found"
        true
      end
    end

    hr = {
        all_count: all.length,
        unscheduled_count: unscheduled.length,
        all: all,
        unscheduled: unscheduled
    }

    return hr
  end


  def sort_poly_lib_paths
    p ""

    p "Sort Poly Lib Paths:"
    p "Available In Lib: #{@poly_lib.keys}"

    ( 1 .. (@poly_lib.keys.length-1) ).each do |iteration|
      p "Iteration: #{iteration}"
      scheduled = 0

      @poly_lib.values.each do |h|
        hr = requires_for(h,iteration)
        if h[:scheduled_compile_order].nil? and ( hr[:unscheduled_count] == 0 )
          p "scheduled #{h[:path]}"
          h[:scheduled_compile_order] = iteration
          scheduled += 1
        end
      end
      break if scheduled == 0
    end

    return get_poly_lib_paths

  end

  def get_javascript_lines
    p "Javascript lines: [These make the files OPAL-ONLY. Badddddd!]"
    @poly_lib.values.each do |h|
        line_number = 1
        h[:js_lines] = []
        h[:source_lines].each do |line|
          if /\`/ =~ line
            h[:js_lines] << {
                line_number: line_number,
                line: line
            }
            line_number += 1
          end
        end
    end
  end

  def copy_to_rb
    @poly_lib.values.each do |h|
      if h[:js_lines].length == 0
        File.open(h[:target_path],'w') do |f|
          h[:source_lines].each do |line|
            f.puts line
          end
        end
      end
    end
  end

  def run_rb_thru_ruby
    @poly_lib.values.each do |h|

      #command = "ruby --verbose -r ./ruby_stubs.rb  #{h[:target_path]}"
      command = "ruby --verbose  #{h[:target_path]}"

      stdin, stdout, stderr, wait_thr = Open3.popen3(command)
      exit_code = wait_thr.value

      if ( h[:ruby_status] = exit_code.exitstatus ) != 0
        p "File: #{h[:target_path]} Command: #{command} failed"
        h[:ruby_passed] = false
      else
        h[:ruby_passed] = true
      end
      h[:ruby_stdout] = stdout.gets(nil)
      h[:ruby_stderr] = stderr.gets(nil)
      stdout.close
      stderr.close
    end
  end

  #n.read_poly_lib_source
  #n.get_poly_lib_javascript
  #n.report_poly_lib_javascript
  #n.create_temp_poly_lib_rb
  #n.run_ruby_on_poly_lib
  #n.require_poly_lib

end

ServiewerEnvironment.require
