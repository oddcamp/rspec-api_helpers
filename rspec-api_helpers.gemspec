# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rspec/api_helpers/version'

Gem::Specification.new do |spec|
  spec.name          = "rspec-api_helpers"
  spec.version       = Rspec::Api::VERSION
  spec.authors       = ["Filippos Vasilakis", "Kollegorna"]
  spec.email         = ["vasilakisfil@gmail.com", "admin@kollegorna.se"]
  spec.summary       = %q{Rspec matchers for APIs}
  spec.description   = %q{Rspec matchers for APIs}
  spec.homepage      = "https://github.com/kollegorna/rspec-api_helpers"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activesupport", "> 4.2"
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
