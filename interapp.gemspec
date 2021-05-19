$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'interapp/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'interapp'
  s.version     = Interapp::VERSION
  s.authors     = ['Ryan Zhou']
  s.email       = ['github@zhoutong.com']
  s.homepage    = 'https://github.com/zhoutong/interapp'
  s.summary     = 'Interapp handles simple and secure inter-app messaging.'
  s.description = 'Interapp is a mountable Rails engine that handles simple and secure inter-app messaging using public key cryptography.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']
  s.test_files = Dir['spec/**/*']

  s.add_dependency 'ecdsa', '~> 1.1.0'
  s.add_dependency 'rails', '>= 5.0.0', '< 7.0'

  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'webmock'
end
