#-*- mode: ruby -*-

spec = eval( File.read( File.expand_path('../../../../jar-dependencies.gemspec', __FILE__ ) ) )

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

  s.add_runtime_dependency 'jar-dependencies', spec.version

  s.requirements << "jar org.bouncycastle:bcpkix-jdk15on, 1.50"
  s.requirements << "jar org.bouncycastle:bcprov-jdk15on, 1.50"
end

# vim: syntax=Ruby
