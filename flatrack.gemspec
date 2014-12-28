# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'flatrack/version'

Gem::Specification.new do |spec|

  # Information
  spec.name        = "flatrack"
  spec.version     = Flatrack::VERSION
  spec.authors     = ["Jason Waldrip"]
  spec.email       = ["jason@waldrip.net"]
  spec.summary     = 'Deliver static files with style.'
  spec.description = <<-description
A rack based static site builder with templates, layouts and project structure
based routing.

  description
  spec.homepage              = "https://github.com/jwaldrip/flatrack"
  spec.license               = "MIT"

  # Files
  spec.files                 = `git ls-files`.split($/)
  spec.executables           = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files            = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths         = ["lib"]

  # Ruby Version
  spec.required_ruby_version = '>= 1.9.3'

  # Dependencies
  spec.add_runtime_dependency 'rack', '~> 1.4'
  spec.add_runtime_dependency 'erubis', '~> 2.7'
  spec.add_runtime_dependency 'tilt', '~> 1.1'
  spec.add_runtime_dependency 'activesupport', ['> 3.2', '< 4.2']
  spec.add_runtime_dependency 'sass', '~> 3.2.0'
  spec.add_runtime_dependency 'sprockets-sass', '~> 1.2'
  spec.add_runtime_dependency 'thor', '~> 0.18'
  spec.add_runtime_dependency 'coffee-script', '~> 2.2'
  spec.add_runtime_dependency 'rake', ['> 0.8.7', '< 10.4']

  # Dev Dependencies
  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rspec', '~> 3.1'
  spec.add_development_dependency 'guard', '~> 2.5'
  spec.add_development_dependency 'guard-rspec', '~> 4.2'
  spec.add_development_dependency 'guard-bundler', '~> 2.0'
  spec.add_development_dependency 'pry', '~> 0.9'
  spec.add_development_dependency 'coveralls', '~> 0.7'
  spec.add_development_dependency 'simplecov', '~> 0.8'
  spec.add_development_dependency 'rubocop', '~> 0.20'
  spec.add_development_dependency 'inch', '~> 0.4'
  spec.add_development_dependency 'yard', '~> 0.3'
end
