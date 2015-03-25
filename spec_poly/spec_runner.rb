#!/usr/bin/env ruby

#require 'tempfile'
require 'tmpdir'
require 'open3'

class SpecRunner
  PREFIX = "../app/assets/javascripts/"

  def run
    p "RSPEC Polymorhic (Ruby/Opal) Runner"
    #read_spec_files
    #infer_source_files
    #read_opal_source
    #get_require_lines
    #get_javascript_lines
    #get_require_lines
    #report_javascript_lines
    #ruby_compile
    environment
    #rspec
  end

  def read_spec_files
    p "Spec Files:"
    @spec_files = Dir.glob('**/*_spec.rb')
    p ""
  end

  def infer_source_files
    p "Inferred Source Files:"
    @inferred_source_files = @spec_files.inject({}) do |h,path|

      path_split = path.split('/')

      s_last = path_split.last
      s_last_0 = s_last.sub(/\.(rb|opal)$/, '')
      s_last_1 = s_last_0.sub(/_spec$/, '')
      s_last_2 = "#{s_last_1}.js.opal"
      last_result = s_last_2

      source_path = [ 'digest-rails', path_split[1..-2], last_result ].join('/')

      h[source_path] = {
          spec_path: path,
          source_path: source_path,
          full_source_path: File.join(PREFIX, source_path )
      }
      h
    end
  end

  def read_opal_source
    p @inferred_source_files.keys.map{ |k| @inferred_source_files[k][:source_path] }
    p ""

    p "Opal source:"
    @inferred_source_files.keys.each do |k|
      h = @inferred_source_files[k]
      if h[:source_exists] = File.exists?( h[:full_source_path] )
        h[:has_js] = false
        h[:source_lines] = []
        File.readlines( h[:full_source_path] ).each do |line|
          h[:source_lines] << line
        end
      end
    end
  end

  def get_require_lines
    p "require lines:"
    @inferred_source_files.keys.each do |k|
      h = @inferred_source_files[k]
      if h[:source_exists]
        line_number = 1
        h[:source_lines].each do |line|
          line_s = line.strip.split(' ').map{|s| s.strip}
          if line_s[0] == 'require'
            require_file = line_s[1].gsub("\"","").gsub("\'","")
    p "REQUIRE #{require_file}"
            if @inferred_source_files[require_file].nil?

            end
          end
          line_number += 1
        end
      end
    end
  end

  def get_javascript_lines
    p "Javascript lines: [These make the files OPAL-ONLY. Badddddd!]"
    @inferred_source_files.keys.each do |k|
      h = @inferred_source_files[k]
      if h[:source_exists]
        h[:source_lines].each do |line|
          if /\`/ =~ line
            h[:has_js] = true
            h[:js_lines] ||= []
            h[:js_lines] << {
                line_number: line_number,
                line: line
            }
            line_number += 1
          end
        end
      end
    end
  end

  def report_javascript_lines
    @inferred_source_files.keys.map do |k|
      h = @inferred_source_files[k]
      if h[:has_js]
        p "File: #{h[:source_path]}"
        h[:js_lines].each do |js_line|
          p "  Line Number: #{js_line[:line_number]} Line: #{js_line[:line]}"
        end
      end
    end
    p ""
  end

  def ruby_compile
    p "Ruby Compile:"
    @inferred_source_files.keys.map do |k|
      h = @inferred_source_files[k]

      command = "ruby --verbose -r ./ruby_stubs.rb  #{h[:full_source_path]}"

      stdin, stdout, stderr, wait_thr = Open3.popen3(command)
      exit_code = wait_thr.value

      status = exit_code.exitstatus

      if status != 0
        p "File: #{h[:full_source_path]} Command: #{command} failed"
        h[:ruby_passed] = false
      else
        h[:ruby_passed] = true
      end
      h[:ruby_stdout] = stdout.gets(nil)
      h[:ruby_stderr] = stderr.gets(nil)
      stdout.close
      stderr.close
      @inferred_source_files[k] = h
    end
  end

  def js_opal_to_rb(source_path,target_dir)
    f_split = source_path.split('/')
    f_last = f_split.last
    f_last_s = f_last.split('.')
    if f_last_s.length == 3 and f_last_s[1] == 'js' and f_last_s[2] == 'opal'
      f_last = [ f_last_s[0], 'rb' ].join('.')
      copy_fn = File.join( target_dir, f_last )
      `cp #{source_path} #{copy_fn}`
      copy_fn
    else
      source_path
    end
  end

  def js_opal_files
    Dir.glob( File.expand_path("../app/assets/javascripts/digest-rails/poly_lib/*.*") )
  end

  def rb_files
    Dir.glob( File.expand_path("../app/assets/javascripts/digest-rails/ruby_lib/*.*") )
  end

  def ruby_files_sorted
    [js_opal_files,rb_files].flatten.sort do |x,y|
      x.split('_')[0] <=> y.split('_')[0]
    end
  end

  def environment
    Dir.mktmpdir("spec_common") do |target_dir|
      ruby_files_sorted.each do |source_path|
        p "Requiring: #{source_path}"
        target_path = js_opal_to_rb( source_path, target_dir )
        require target_path
      end
    end
  end

  def rspec
    p "RSpec:"
    @inferred_source_files.keys.map do |k|
      h = @inferred_source_files[k]
      p command = "rspec -I ../app/assets/javascripts --require ./ruby_stubs #{h[:full_source_path]} #{h[:spec_path]}"
      #p command = "rspec --require ./ruby_stubs #{h[:spec_path]}"

      stdin, stdout, stderr, wait_thr = Open3.popen3(command)
      exit_code = wait_thr.value

      status = exit_code.exitstatus

      if status != 0
        p "File: #{h[:full_source_path]}"
        p "Command: #{command}"
        p "Failed...."
        h[:rspec_passed] = false
      else
        h[:rspec_passed] = true
      end

      (h[:rspec_stderr] = stderr_content = stderr.gets(nil))
      if stderr_content
        stderr_content.split("\n").each{|l| p l}
      end

      p ""
      h[:rspec_stdout] = stdout_content = stdout.gets(nil)
      if stdout_content
        stdout_content.split("\n").each{|l| p l}
      end

      stdout.close
      stderr.close
      @inferred_source_files[k] = h

    end

  end

end

SpecRunner.new.run
