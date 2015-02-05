#-*- mode: ruby -*-

spec = eval( File.read( File.expand_path( '../../../../jar-dependencies.gemspec', __FILE__ ) ) )

Gem::Specification.new do |s|
  s.name = 'my'
  s.version = '1.1.1'
  s.author = 'example person'
  s.email = [ 'mail@example.com' ]
  s.summary = 'test gem'

  s.files << Dir[ 'lib/**/*.rb' ]
  s.files << Dir[ '*file' ]
  s.files << 'my.gemspec'

  s.add_runtime_dependency 'jar-dependencies', spec.version

  s.requirements << "jar 'com.fasterxml.jackson.core:jackson-core', '2.3.0'"
end

# vim: syntax=Ruby
