# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'adobe_connect/version'

Gem::Specification.new do |gem|
  gem.name          = "adobe_connect"
  gem.version       = AdobeConnect::VERSION
  gem.authors       = ["Zach Pendleton"]
  gem.email         = ["zachpendleton@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'activesupport', '>= 2.3.16'
  gem.add_dependency 'nokogiri',      '~> 1.5.6'
  gem.add_dependency 'rake',          '~> 10.0.3'

  gem.add_development_dependency 'minitest', '~> 4.6.0'
  gem.add_development_dependency 'mocha',    '~> 0.13.2'
  gem.add_development_dependency 'pry',      '~> 0.9.11.4'
end
