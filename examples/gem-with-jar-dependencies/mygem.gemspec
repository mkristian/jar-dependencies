#-*- mode: ruby -*-

# use the version from the main project
require "#{File.dirname File.expand_path(__FILE__)}/../../lib/jars/version"

Gem::Specification.new do |s|
  s.name = File.basename(File.dirname(File.expand_path(__FILE__)))
  s.version = '1.0.0'
  s.author = ['example person']
  s.email = ['mail@example.com']
  s.summary = "summary of #{s.name}"
  s.description = "description of #{s.name}"

  # important to get the jars installed
  s.platform = 'java'

  s.files = Dir['lib/**/*.rb']
  s.files += Dir['lib/*.jar']
  s.files += Dir['*file']
  s.files += Dir['*.gemspec']

  s.requirements << 'jar org.slf4j, slf4j-api, 1.7.7'
  s.requirements << 'jar org.slf4j, slf4j-simple, 1.7.7, :scope => :test'

  s.add_runtime_dependency 'jar-dependencies', "~> #{Jars::VERSION}"
end

# vim: syntax=Ruby
