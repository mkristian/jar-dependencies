#-*- mode: ruby -*-

Gem::Specification.new do |s|

  # this is only needed to retrieve the latest version of jar-dependencies
  # so this can run as integration-test
  version = ENV_JAVA['jar-dependencies.version'] || '0.3.0'
  
  s.name = 'example'
  s.version = "2"
  s.author = 'example person'
  s.email = [ 'mail@example.com' ]
  s.summary = 'gem with jar'
  s.description = 'gem with empty jar and jar dependencies'

  # important so jar-dependencies knows it should look for
  # jar declarations in the requirements section !
  s.platform = 'java'

  s.files << Dir[ 'lib/**/*.rb' ]
  s.files << 'lib/example.jar'
  s.files << Dir[ '*file' ]
  s.files << 'example.gemspec'

  # constrain the version of jar-dependencies itself
  s.add_runtime_dependency 'jar-dependencies', "~> #{version}"

  # the jar declarations
  s.requirements << "jar org.bouncycastle:bcpkix-jdk15on, 1.49"
  s.requirements << "jar org.bouncycastle:bcprov-jdk15on, 1.49"
  s.requirements << "jar org.slf4j:slf4j-api, 1.7.7"

  # needed for the tests
  s.requirements << "jar org.slf4j:slf4j-simple, 1.7.7, :scope => :test"

  s.add_development_dependency 'rspec', '~> 2.14'
  s.add_development_dependency 'rake', '~> 10.3'

  # needed to compile src/main/java/** into lib/example.jar
  s.add_development_dependency 'rake-compiler', '~> 0.9'
  
  # avoids to install it on the fly when jar-dependencies needs it
  s.add_development_dependency 'ruby-maven', '~> 3.3', '>= 3.3.8'

end

# vim: syntax=Ruby
