$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "digest-rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "digest-rails"
  s.version     = DigestRails::VERSION
  s.authors     = ["Eric Laquer","Ben Cavalier"]
  s.email       = ["LaquerEric@gmail.com", "bcavileer@holmanauto.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of DigestRails."
  s.description = "TODO: Description of DigestRails."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 3.2.21"
  s.add_dependency "axle"

  s.add_development_dependency "rspec-rails", "~> 3.1"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency 'pry-rescue'
  s.add_development_dependency 'pry-stack_explorer'
end
