#-*- mode: ruby -*-

Gem::Specification.new do |s|
  s.name = 'first'
  s.version = '1'
  s.author = 'example person'
  s.email = [ 'mail@example.com' ]
  s.summary = 'first gem with jars vendored during installation'

  s.files << Dir[ 'lib/**/*.rb' ]
  s.files << Dir[ '*file' ]
  s.files << 'first.gemspec'

  s.add_runtime_dependency 'jar-dependencies'

  s.requirements << "jar org.bouncycastle:bcpkix-jdk15on, 1.49"
  s.requirements << "jar org.bouncycastle:bcprov-jdk15on, 1.49"
end

# vim: syntax=Ruby
