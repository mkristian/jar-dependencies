# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'foo'
  s.version = '0.0.1'
  s.authors = ['foo']
  s.summary = 'foo'
  s.requirements << 'jar io.dropwizard.metrics:metrics-healthchecks, 3.1.0'
  s.platform = 'java'
  s.required_ruby_version = '>= 2.6'
  s.add_runtime_dependency 'jar-dependencies'
  s.metadata['rubygems_mfa_required'] = 'true'
end
