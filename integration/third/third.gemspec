#-*- mode: ruby -*-

Gem::Specification.new do |s|
  s.name = 'third'
  s.version = '3'
  s.author = 'example person'
  s.email = [ 'mail@example.com' ]
  s.summary = 'third gem with embedded jars'

  s.files << Dir[ 'lib/**/*.rb' ]
  s.files << Dir[ 'lib/**/*.jar' ]
  s.files << Dir[ '*file' ]
  s.files << 'third.gemspec'

  s.add_runtime_dependency 'jar-dependencies', '~> 0.0.5'

  s.requirements << "jar org.bouncycastle:bcpkix-jdk15on, 1.50"
  s.requirements << "jar org.bouncycastle:bcprov-jdk15on, 1.50"
end

# vim: syntax=Ruby
