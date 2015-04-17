#-*- mode: ruby -*-

Gem::Specification.new do |s|
  s.name = 'jar-dependencies'

  path = File.expand_path('lib/jars/version.rb', File.dirname(__FILE__))
  s.version = File.read(path).match( /.*VERSION\s*=\s*['"](.*)['"]/m )[1]
  
  s.author = 'christian meier'
  s.email = [ 'mkristian@web.de' ]
  s.summary = 'manage jar dependencies for gems'
  s.homepage = 'https://github.com/mkristian/jar-dependencies'

  s.license = 'MIT'

  s.files = `git ls-files`.split($/).select do |file|
    file =~ /^lib\// ||
    [ 'Mavenfile', 'Rakefile' ].include?(file) ||
    [ 'Readme.md', 'jar-dependencies.gemspec', 'MIT-LICENSE' ].include?(file)
  end

  s.description = 'manage jar dependencies for gems and keep track which jar was already loaded using maven artifact coordinates. it warns on version conflicts and loads only ONE jar assuming the first one is compatible to the second one otherwise your project needs to lock down the right version by providing a Jars.lock file.'

  s.add_development_dependency 'minitest', '~> 5.3'
  s.add_development_dependency 'rake', '~> 10.2'
  s.add_development_dependency 'ruby-maven', '~> 3.1.1.0.11'
end

# vim: syntax=Ruby
