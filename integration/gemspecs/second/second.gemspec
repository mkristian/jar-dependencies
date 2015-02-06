#-*- mode: ruby -*-

spec = eval( File.read( File.expand_path('../../../../jar-dependencies.gemspec', __FILE__ ) ) )

Gem::Specification.new do |s|
  s.name = 'second'
  s.version = '2'
  s.author = 'example person'
  s.email = [ 'mail@example.com' ]
  s.summary = 'second gem with jars dependency declaration only'

  s.files << Dir[ 'lib/**/*.rb' ]
  s.files << Dir[ '*file' ]
  s.files << 'second.gemspec'

  s.add_development_dependency 'jar-dependencies', spec.version

  s.requirements << "jar org.bouncycastle:bcpkix-jdk15on, 1.48"
  s.requirements << "jar org.bouncycastle:bcprov-jdk15on, 1.48"
end

# vim: syntax=Ruby
