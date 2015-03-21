#!/usr/bin/env ruby
require 'tempfile'
require 'open3'

p "RSPEC Polymorhic (Ruby/Opal) Runner"

PREFIX = "../app/assets/javascripts/"

p "Spec Files:"
p spec_files = Dir.glob('**/*_spec.rb')
p ""
p "Inferred Source Files:"
inferred_source_files = spec_files.inject({}) do |h,path|

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

p inferred_source_files.keys.map{ |k| inferred_source_files[k][:source_path] }
p ""

p "Javascript lines: [These make the files OPAL-ONLY. Badddddd!]"
inferred_source_files.keys.each do |k|
  h = inferred_source_files[k]

  if h[:source_exists] = File.exists?( h[:full_source_path] )
    h[:has_js] = false
    line_number = 1
    File.readlines( h[:full_source_path] ).each do |line|
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
inferred_source_files.keys.map do |k|
  h = inferred_source_files[k]
  if h[:has_js]
    p "File: #{h[:source_path]}"
    h[:js_lines].each do |js_line|
      p "  Line Number: #{js_line[:line_number]} Line: #{js_line[:line]}"
    end
  end
end
p ""

p "Ruby Compile:"

inferred_source_files.keys.map do |k|
  h = inferred_source_files[k]

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
  inferred_source_files[k] = h

end

p "RSpec:"
inferred_source_files.keys.map do |k|
  h = inferred_source_files[k]
  #p command = "rspec --require ./ruby_stubs --require #{h[:full_source_path]} #{h[:spec_path]}"
  p command = "rspec --require ./ruby_stubs #{h[:spec_path]}"

  stdin, stdout, stderr, wait_thr = Open3.popen3(command)
  exit_code = wait_thr.value

  status = exit_code.exitstatus

  if status != 0
    p "File: #{h[:full_source_path]}"
    p "Command: #{command}"
    p " failed"
    h[:rspec_passed] = false
  else
    h[:rspec_passed] = true
  end
  (h[:rspec_stderr] = stderr_content = stderr.gets(nil))
  if stderr_content
    stderr_content.split("\n").each{|l| p l}
  end
  p ""
  p h[:rspec_stdout] = stdout.gets(nil)

  stdout.close
  stderr.close
  inferred_source_files[k] = h

end
