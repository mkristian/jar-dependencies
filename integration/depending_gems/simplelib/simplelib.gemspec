#-*- mode: ruby -*-

Gem::Specification.new do |s|
  s.name = 'simplelib'
  s.version = '1'
  s.author = 'christian meier'
  s.email = ['m.kristian@web.de']

  s.platform = 'java'
  s.license = 'MIT'
  s.summary = 'simplelib'
  s.homepage = 'https://example.com'
  s.description = 'more examples'

  s.requirements << 'jar io.dropwizard.metrics:metrics-core, 3.1.0'

  s.add_runtime_dependency 'jar-dependencies'
end

# vim: syntax=Ruby
