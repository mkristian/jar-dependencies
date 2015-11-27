#-*- mode: ruby -*-

require "#{File.dirname File.expand_path(__FILE__)}/../lib/jars/version"

Gem::Specification.new do |s|
  s.name = 'example'
  s.version = "2"
  s.author = 'example person'
  s.email = [ 'mail@example.com' ]
  s.summary = 'gem with jar'
  s.description = 'gem with empty jar and jar dependencies'

  s.platform = 'java'

  s.files << Dir[ 'lib/**/*.rb' ]
  s.files << 'lib/example.jar'
  s.files << Dir[ '*file' ]
  s.files << 'example.gemspec'

  s.add_runtime_dependency 'jar-dependencies', "~> #{Jars::VERSION}"

  s.requirements << "jar org.bouncycastle:bcpkix-jdk15on, 1.49"
  s.requirements << "jar org.bouncycastle:bcprov-jdk15on, 1.49"
  s.requirements << "jar junit:junit, 4.1, :scope => :test"
  s.requirements << "jar org.jruby:jruby-core, 1.7.12, :scope => :provided"

  s.add_development_dependency 'rspec', '~> 2.14.0'
  s.add_development_dependency 'rake', '~> 10.3.2'
  # needed to compile src/main/java/** into lib/example.jar
  s.add_development_dependency 'ruby-maven', '~> 3.1.1.0'
end

# vim: syntax=Ruby
