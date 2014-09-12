#-*- mode: ruby -*-

Gem::Specification.new do |s|
  s.name = 'forth'
  s.version = "4"
  s.author = 'example person'
  s.email = [ 'mail@example.com' ]
  s.summary = 'forth gem depending on the other gems'

  s.files << Dir[ 'lib/**/*.rb' ]
  s.files << Dir[ '*file' ]
  s.files << 'forth.gemspec'

  s.add_runtime_dependency 'first', '1'
  s.add_runtime_dependency 'second', '2'
  s.add_runtime_dependency 'third', '3'
end

# vim: syntax=Ruby
