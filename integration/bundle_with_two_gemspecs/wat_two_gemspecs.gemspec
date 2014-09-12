# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wat_two_gemspecs/version'

Gem::Specification.new do |spec|
  spec.name          = "wat_two_gemspecs"
  spec.version       = WatTwoGemspecs::VERSION
  spec.authors       = ["Jason R. Clark"]
  spec.email         = ["jclark@newrelic.com"]
  spec.summary       = %q{Wat, two gemspecs?}
  spec.description   = %q{Are you crazy?}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
