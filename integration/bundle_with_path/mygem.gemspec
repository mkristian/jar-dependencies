#-*- mode: ruby -*-

Gem::Specification.new do |s|
  s.name = "foo"
  s.version = "0.0.1"
  s.authors = ["foo"]
  s.summary = "foo"
  s.requirements << 'jar io.dropwizard.metrics:metrics-healthchecks, 3.1.0'
  s.platform = 'java'
  s.add_runtime_dependency 'jar-dependencies'
end

# vim: syntax=Ruby
