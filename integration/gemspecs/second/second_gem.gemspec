#-*- mode: ruby -*-

Gem::Specification.new do |s|
  s.name = 'second_gem'
  s.version = '2'
  s.author = 'example person'
  s.email = [ 'mail@example.com' ]
  s.summary = 'second gem with jars dependency declaration only'

  s.files << Dir[ 'lib/**/*.rb' ]
  s.files << Dir[ '*file' ]
  s.files << 'second_gem.gemspec'

  s.add_development_dependency 'jar-dependencies'

  s.requirements << "jar org.bouncycastle:bcpkix-jdk15on, 1.48"
  s.requirements << "jar org.bouncycastle:bcprov-jdk15on, 1.48"
end

# vim: syntax=Ruby
