# frozen_string_literal: true

require File.expand_path('setup', File.dirname(__FILE__))

require 'jars/maven_factory'

describe Jars::MavenFactory do
  after do
    ENV['JARS_VERBOSE'] = nil
    ENV['JARS_DEBUG'] = nil
    ENV['JARS_MAVEN_SETTINGS'] = nil
    Jars.reset
  end

  it 'uses logging config' do
    ENV['JARS_VERBOSE'] = nil
    ENV['JARS_DEBUG'] = nil
    Jars.reset
    maven = Jars::MavenFactory.new.maven_new('pom')
    maven.options.key?('--quiet').must_equal true
    maven.options.key?('-X').must_equal false
    maven.options['-Dverbose'].must_equal false

    ENV['JARS_VERBOSE'] = 'true'
    ENV['JARS_DEBUG'] = nil
    Jars.reset
    maven = Jars::MavenFactory.new.maven_new('pom')
    maven.options.key?('--quiet').must_equal false
    maven.options.key?('-e').must_equal true
    maven.options.key?('-X').must_equal false
    maven.options['-Dverbose'].must_equal true

    ENV['JARS_VERBOSE'] = nil
    ENV['JARS_DEBUG'] = 'true'
    Jars.reset
    maven = Jars::MavenFactory.new.maven_new('pom')
    maven.options.key?('--quiet').must_equal false
    maven.options.key?('-e').must_equal false
    maven.options.key?('-X').must_equal true
    maven.options['-Dverbose'].must_equal true

    ENV['JARS_VERBOSE'] = 'true'
    ENV['JARS_DEBUG'] = 'true'
    Jars.reset
    maven = Jars::MavenFactory.new.maven_new('pom')
    maven.options.key?('--quiet').must_equal false
    maven.options.key?('-e').must_equal true
    maven.options.key?('-X').must_equal true
    maven.options['-Dverbose'].must_equal true
  end

  it 'uses proxy settings from Gem.configuration' do
    skip('pending until it realy works')
    ENV['JARS_MAVEN_SETTINGS'] = 'specs/does/no/exists/settings.xml'
    Gem.configuration[:proxy] = 'https://localhost:3128'
    Jars.reset
    maven = Jars::MavenFactory.new.maven_new('pom')
    maven.options.key?('-DproxySet=true').must_equal true
    maven.options.key?('-DproxyHost=localhost').must_equal true
    maven.options.key?('-DproxyPort=3128').must_equal true

    Gem.configuration[:proxy] = :noproxy
    Jars.reset
    maven = Jars::MavenFactory.new.maven_new('pom')
    maven.options.key?('-DproxySet=true').must_equal false
    maven.options.key?('-DproxyHost=localhost').must_equal false
    maven.options.key?('-DproxyPort=3128').must_equal false

    ENV['JARS_MAVEN_SETTINGS'] = 'specs/settings.xml'
    Gem.configuration[:proxy] = 'https://localhost:3128'
    Jars.reset
    maven = Jars::MavenFactory.new.maven_new('pom')
    maven.options.key?('-DproxySet=true').must_equal false
    maven.options.key?('-DproxyHost=localhost').must_equal false
    maven.options.key?('-DproxyPort=3128').must_equal false
  end
end
