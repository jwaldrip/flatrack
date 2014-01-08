# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'flatrack/version'

Gem::Specification.new do |spec|
  spec.name          = "flatrack"
  spec.version       = Flatrack::VERSION
  spec.authors       = ["Jason Waldrip"]
  spec.email         = ["jason@waldrip.net"]
  spec.summary       = 'A template based flat rack site'
  spec.homepage      = "https://github.com/jwaldrip/flatrack"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'rack'
  spec.add_dependency 'activesupport'
  spec.add_dependency 'sass'
  spec.add_dependency 'sprockets'
  spec.add_dependency 'thor'
  spec.add_dependency 'coffee-script'
  spec.add_dependency 'rake'

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rspec'
end
