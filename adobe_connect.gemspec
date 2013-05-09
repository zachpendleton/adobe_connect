# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'adobe_connect/version'

Gem::Specification.new do |gem|
  gem.name          = 'adobe_connect'
  gem.version       = AdobeConnect::VERSION
  gem.authors       = ['Zach Pendleton']
  gem.email         = ['zachpendleton@gmail.com']
  gem.description   = %q{An API wrapper for interacting with Adobe Connect services.}
  gem.summary       = %q{An API wrapper for Adobe Connect services.}
  gem.license       = 'MIT'
  gem.homepage      = 'https://github.com/zachpendleton/adobe_connect'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'activesupport', '>= 2.3.17'
  gem.add_dependency 'nokogiri',      '~> 1.5.5'
  gem.add_dependency 'rake',          '>= 0.9.2'

  gem.add_development_dependency 'minitest',    '~> 4.6.0'
  gem.add_development_dependency 'mocha',       '~> 0.13.2'
  gem.add_development_dependency 'pry',         '>= 0.9.11.4'
  gem.add_development_dependency 'redcarpet'
  gem.add_development_dependency 'yard',        '~> 0.8.4.1'
  gem.add_development_dependency 'yard-tomdoc', '~> 0.6.0'
end
