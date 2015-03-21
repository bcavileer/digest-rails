#!/usr/bin/env rake
#begin
#  require 'bundler/setup'
#rescue LoadError
#  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
#end
#APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)
#load 'rails/tasks/engine.rake'
#Bundler::GemHelper.install_tasks
#Dir[File.join(File.dirname(__FILE__), 'tasks/**/*.rake')].each {|f| load f }
#require 'rspec/core'
#require 'rspec/core/rake_task'
#desc "Run all specs in spec directory (excluding plugin specs)"
#RSpec::Core::RakeTask.new(:spec_opal => 'app:db:test:prepare')
#task :default => :spec_opal





#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

#desc ":map_spec_ruby"
#task :map_spec_ruby do
#  `rm spec`
#  `ln -s ./spec_ruby spec`
  #APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)
  #load 'rails/tasks/engine.rake'
  #Bundler::GemHelper.install_tasks
  #Dir[File.join(File.dirname(__FILE__), 'tasks/**/*.rake')].each {|f| load f }
  #require 'rspec/core'
#end

#require 'rspec/core/rake_task'
#desc "Run all ruby specs in spec_ruby"
#RSpec::Core::RakeTask.new() #:spec => 'app:db:test:prepare')

desc ":map_spec_opal"
task :map_spec_opal do
  `rm -d spec`
  `ln -s ./spec_opal spec`
end

require 'opal/rspec/rake_task'
desc "Run all opal specs in spec_opal"
Opal::RSpec::RakeTask.new(:opal_rspec)

#desc "Start opal spec server"
#task :start_spec_opal => :map_spec_opal do
#  `rackup config_opal_rspec.ru`
#end

#task :spec_ruby_opal => [ :map_spec_ruby, :spec, :map_spec_opal, :opal_rspec] do
#end

#task :default => :spec_ruby_opal

require 'opal'
require 'opal-rspec'



#Opal::RSpec::Runner.autorun