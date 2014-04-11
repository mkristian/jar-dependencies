#-*- mode: ruby -*-

Gem::Specification.new do |s|
  s.name = 'jar-dependencies'
  s.version = "0.0.2"
  s.author = 'christian meier'
  s.email = [ 'mkristian@web.de' ]
  s.summary = 'manage jar dependencies for gems'
  s.homepage = 'https://github.com/mkristian/jar-dependencies'

  s.license = 'MIT'

  s.files = Dir[ 'lib/*rb' ]
  s.files += Dir[ '*file' ]
  s.files += [ 'Readme.md', 'jar-dependencies.gemspec', 'MIT-LICENSE' ]

  s.description = 'manage jar dependencies for gems and keep track which jar was already loaded using maven artifact coordinates. it warns on version conflicts and loads only ONE jar assuming the first one is compatible to the second one otherwise your project needs to lock down the right version.'

  s.add_development_dependency 'rake', '~> 10.2.2'
  s.add_development_dependency 'ruby-maven', '~> 3.1.1.0'
end

# vim: syntax=Ruby
