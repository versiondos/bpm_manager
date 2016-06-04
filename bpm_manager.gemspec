# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bpm_manager/version'

Gem::Specification.new do |spec|
  spec.name          = "bpm_manager"
  spec.version       = BpmManager::VERSION
  spec.authors       = ["Ariel Presa"]
  spec.email         = ["arielpresa@gmail.com"]
  spec.summary       = %q{BPM Manager Gem for RedHat BPM engine.}
  spec.description   = %q{Simple BPM integration with RedHat BPM engine. Use this gem to avoid REST calls in your code. Enjoy.}
  spec.homepage      = "http://www.beatcoding.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'rest-client'

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
end
