# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wat_two_gemspecs/version'

Gem::Specification.new do |spec|
  spec.name          = 'wat_two_gemspecs'
  spec.version       = WatTwoGemspecs::VERSION
  spec.authors       = ['Jason R. Clark']
  spec.email         = ['jclark@newrelic.com']
  spec.summary       = 'Wat, two gemspecs?'
  spec.description   = 'Are you crazy?'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  s.required_ruby_version = '>= 2.6'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
