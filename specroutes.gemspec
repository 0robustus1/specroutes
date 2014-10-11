$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "specroutes/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "specroutes"
  s.version     = Specroutes::VERSION
  s.authors     = ['Tim Reddehase']
  s.email       = ['uni@rightsrestricted.com']
  s.homepage    = 'masterthesis.rightsrestricted.com'
  s.summary     = 'Generate WADL specification from routes.'
  s.description = 'Generate WADL specification from routes.'

  s.files = Dir['{app,config,db,lib}/**/*'] + ['MIT-LICENSE', 'Rakefile', "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.19"

  s.add_development_dependency "sqlite3"
end
