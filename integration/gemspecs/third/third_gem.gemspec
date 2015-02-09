#-*- mode: ruby -*-

Gem::Specification.new do |s|
  s.name = 'third_gem'
  s.version = '3'
  s.author = 'example person'
  s.email = [ 'mail@example.com' ]
  s.summary = 'third gem with embedded jars'

  s.files << Dir[ 'lib/**/*.rb' ]
  s.files << Dir[ 'lib/**/*.jar' ]
  s.files << Dir[ '*file' ]
  s.files << 'third_gem.gemspec'

  s.add_runtime_dependency 'jar-dependencies'

  s.requirements << "jar org.bouncycastle:bcpkix-jdk15on, 1.50"
  s.requirements << "jar org.bouncycastle:bcprov-jdk15on, 1.50"
end

# vim: syntax=Ruby
