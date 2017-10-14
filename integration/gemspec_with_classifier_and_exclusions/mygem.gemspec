#-*- mode: ruby -*-

Gem::Specification.new do |s|
  s.name = 'mygem'
  s.version = '0.0.1'
  s.authors = ['foo']
  s.summary = 'foo'
  s.requirements << 'jar io.dropwizard:dropwizard-logging, 0.8.0-rc5, :exclusions=> [ joda-time:joda-time ]'
  s.requirements << 'jar com.google.protobuf:protobuf-java, 2.2.0, :classifier => lite'
  s.requirements << 'jar org.slf4j:slf4j-simple:1.7.7, :scope => :provided'
  s.requirements << 'jar junit:junit:4.12, :scope => :test'
  s.platform = 'java'
  s.add_runtime_dependency 'jar-dependencies'
end

# vim: syntax=Ruby
