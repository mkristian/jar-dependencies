#-*- mode: ruby -*-

Gem::Specification.new do |s|
  s.name = 'example'
  s.version = "2"
  s.author = 'example person'
  s.email = [ 'mail@example.com' ]
  s.summary = 'gem with jar'
  s.description = 'gem with empty jar and jar dependencies'

  s.files << Dir[ 'lib/**/*.rb' ].reject{ |d| d == 'lib/example_jars.rb' }
  s.files << 'lib/example.jar'
  s.files << Dir[ '*file' ]
  s.files << 'example.gemspec'

  s.add_runtime_dependency 'jar-dependencies', '~>0.0.2'

  s.requirements << "jar org.bouncycastle:bcpkix-jdk15on, 1.49"
  s.requirements << "jar org.bouncycastle:bcprov-jdk15on, 1.49"
end

# vim: syntax=Ruby
