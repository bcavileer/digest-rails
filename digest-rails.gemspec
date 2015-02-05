$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "digest-rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "digest-rails"
  s.version     = DigestRails::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of DigestRails."
  s.description = "TODO: Description of DigestRails."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 3.2.21"
  s.add_dependency "opal-rails"
  s.add_dependency "foundation-rails"
  s.add_dependency "digest"

  s.add_development_dependency 'rspec-rails', "~> 3.1"
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'pry-rescue'
  s.add_development_dependency 'pry-stack_explorer'

  s.add_development_dependency "sqlite3"
end
