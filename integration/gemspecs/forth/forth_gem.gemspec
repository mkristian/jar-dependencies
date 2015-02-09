#-*- mode: ruby -*-

Gem::Specification.new do |s|
  s.name = 'forth_gem'
  s.version = "4"
  s.author = 'example person'
  s.email = [ 'mail@example.com' ]
  s.summary = 'forth gem depending on the other gems'

  s.files << Dir[ 'lib/**/*.rb' ]
  s.files << Dir[ '*file' ]
  s.files << 'forth_gem.gemspec'

  s.add_runtime_dependency 'first_gem', '1'
  s.add_runtime_dependency 'second_gem', '2'
  s.add_runtime_dependency 'third_gem', '3'
end

# vim: syntax=Ruby
