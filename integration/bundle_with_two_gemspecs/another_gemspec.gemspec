# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'another_gemspec/version'

Gem::Specification.new do |spec|
  spec.name          = 'another_gemspec'
  spec.version       = AnotherGemspec::VERSION
  spec.authors       = ['Jason R. Clark']
  spec.email         = ['jclark@newrelic.com']
  spec.summary       = 'Wat, two gemspecs?'
  spec.description   = 'Are you crazy?'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.metadata['rubygems_mfa_required'] = 'true'
  spec.required_ruby_version = '>= 2.6'
end
