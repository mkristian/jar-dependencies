#-*- mode: ruby -*-

Gem::Specification.new do |s|
  s.name = 'second'
  s.version = "1"
  s.author = 'example person'
  s.email = [ 'mail@example.com' ]
  s.summary = 'second gem depending on first gem'
  s.description = 'gem with jar dependencies'

  s.files << Dir[ 'lib/**/*.rb' ]
  s.files << Dir[ '*file' ]
  s.files << 'second.gemspec'

  s.add_runtime_dependency 'first', '1'
end

# vim: syntax=Ruby
