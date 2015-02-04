#-*- mode: ruby -*-

spec = eval( File.read( File.expand_path('../../../jar-dependencies.gemspec', __FILE__ ) ) )

Gem::Specification.new do |s|
  s.name = "foo"
  s.version = "0.0.1"
  s.authors = ["foo"]
  s.summary = "foo"
  s.requirements << 'jar io.dropwizard.metrics:metrics-healthchecks, 3.1.0'

  s.add_runtime_dependency 'jar-dependencies', spec.version
end

# vim: syntax=Ruby
