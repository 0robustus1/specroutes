$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "specroutes/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "specroutes"
  s.version     = Specroutes::VERSION
  s.authors     = ['Tim Reddehase']
  s.email       = ['uni@rightsrestricted.com']
  s.homepage    = 'http://masterthesis.rightsrestricted.com'
  s.summary     = 'Generate WADL specification from routes.'
  s.description = 'Generate WADL specification from routes.'

  s.files = Dir['{app,config,db,lib}/**/*'] + ['MIT-LICENSE', 'Rakefile', "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.21"
  s.add_dependency "libxml-ruby", "~> 2.8.0"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails", "~> 3.2.1"
  s.add_development_dependency "pry", "~> 0.9"
  s.add_development_dependency "pry-rails", "~> 0.3.4"
  s.add_development_dependency "pry-doc", "~> 0.6.0"
  s.add_development_dependency "pry-byebug", "~> 3.1.0"
  s.add_development_dependency "simplecov", "~> 0.10.0"
  s.add_development_dependency "coveralls", "~> 0.8.1"
end
