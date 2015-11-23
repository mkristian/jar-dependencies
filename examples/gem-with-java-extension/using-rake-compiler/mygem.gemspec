#-*- mode: ruby -*-

# use the version from the main project
require "#{File.dirname File.expand_path(__FILE__)}/../../../lib/jars/version"

Gem::Specification.new do |s|
  s.name = File.basename( File.dirname( File.expand_path( __FILE__ ) ) )
  s.version = "1.0.0"
  s.author = [ 'example person' ]
  s.email = [ 'mail@example.com' ]
  s.summary = "summary of #{s.name}"
  s.description = "description of #{s.name}"

  # nice to have
  s.platform = 'java'

  s.files = Dir[ 'lib/**/*.rb' ]
  s.files += Dir[ 'lib/*.jar' ]
  s.files += Dir[ '*.file' ]
  s.files += Dir[ '*.gemspec' ]
  
  s.add_development_dependency 'rake', '~> 10.3'
  # needed to compile src/main/java/** and create jar file
  s.add_development_dependency 'rake-compile', '~> 0.9'
end

# vim: syntax=Ruby
