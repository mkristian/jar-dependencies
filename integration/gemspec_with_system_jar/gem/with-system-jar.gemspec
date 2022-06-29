# frozen_string_literal: true

require_relative '../../../lib/jars/version'

Gem::Specification.new do |s|
  s.name = 'with-system-jar'
  s.version = '1.1.1'
  s.author = 'example person'
  s.email = ['mail@example.com']
  s.summary = 'first gem with jars vendored during installation'

  s.platform = 'java'
  s.files = Dir['lib/**/*.rb'] + Dir['*.gemspec']

  s.required_ruby_version = '>= 2.6'

  s.add_runtime_dependency 'jar-dependencies', Jars::VERSION

  s.requirements << "jar 'org.apache.hbase:hbase-annotations', '=0.98.7-hadoop2'"
  s.metadata['rubygems_mfa_required'] = 'true'
end
