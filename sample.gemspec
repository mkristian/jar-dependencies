#-*- mode: ruby -*-

Gem::Specification.new do |s|
  s.name = 'sample'
  s.version = "2"
  s.author = 'sample person'
  s.email = [ 'mail@example.com' ]
  s.summary = 'gem with jar'
  s.description = 'gem with empty jar and jar dependencies'

  s.extensions << 'Rakefile'

  s.files << Dir[ 'lib/**/*.rb' ]
  s.files << Dir[ 'lib/**/*.jar' ]
  s.files << Dir[ '*file' ]
  s.files << 'sample.gemspec'

  s.add_runtime_dependency 'jar-dependencies', '0.0.1'

  s.requirements << "jar org.bouncycastle:bcpkix-jdk15on, 1.49"
  s.requirements << "jar org.bouncycastle:bcprov-jdk15on, 1.49"
end

# vim: syntax=Ruby

