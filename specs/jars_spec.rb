require File.expand_path('setup', File.dirname(__FILE__))
require 'jar_dependencies'
require 'stringio'
describe Jars do

  @@_env_ = ENV.dup

  before do
    Jars.reset
  end

  after do
    ENV.clear; ENV.replace @@_env_ # restore ENV
  end

  it 'extract property' do
    ENV['SOME_JARS_HOME'] = 'bla'
    Jars.to_prop( 'some_jars_home' ).must_equal 'bla'
    if defined? JRUBY_VERSION
      java.lang.System.set_property( 'some.jars.home', 'blabla' )
      Jars.to_prop( 'some_jars_home' ).must_equal 'blabla'
    end
  end

  it 'extract maven settings' do
    settings = Jars.maven_settings
    settings.sub( /.*\.m2./, '' ).must_equal 'settings.xml'

    ENV['JARS_MAVEN_SETTINGS'] = 'specs/settings.xml'
    Jars.reset
    settings.wont_equal Jars.maven_settings
    Jars.maven_settings.must_equal File.expand_path( 'specs/settings.xml' )

    ENV['JARS_MAVEN_SETTINGS'] = nil
  end

  it 'determines JARS_HOME' do
    ENV['M2_HOME'] = ENV['MAVEN_HOME'] = '' # so that it won't interfere
    ENV['JARS_QUIET'] = 'true'
    ENV['JARS_MAVEN_SETTINGS'] = 'does-not-exist/settings.xml'
    home = Jars.home
    home.must_equal( File.join( ENV[ 'HOME' ], '.m2', 'repository' ) )

    ENV['JARS_MAVEN_SETTINGS'] = File.join( 'specs', 'settings.xml' )
    Jars.reset
    Jars.home.wont_equal home
    Jars.home.must_equal "specs"

    ENV['JARS_MAVEN_SETTINGS'] = nil
  end

  it "determines JARS_HOME (when no ENV['HOME'] present)" do
    ENV['M2_HOME'] = ENV['MAVEN_HOME'] = '' # so that it won't interfere
    env_home = ENV[ 'HOME' ]; ENV.delete('HOME')
    ENV['JARS_QUIET'] = true.to_s
    ENV['JARS_MAVEN_SETTINGS'] = 'does-not-exist/settings.xml'
    Jars.home.must_equal( File.join( env_home, '.m2', 'repository' ) )
  end

  it "determines JARS_HOME (from global settings.xml)" do
    ENV[ 'HOME' ] = "/tmp/oul'bollocks!"
    ENV[ 'M2_HOME' ] = File.expand_path(File.dirname(__FILE__))
    ENV_JAVA[ 'repo.path' ] = 'specs'
    Jars.home.must_equal( 'specs/repository' )
  end

  it 'raises RuntimeError on requires of unknown jar' do
    lambda { require_jar( 'org.something', 'slf4j-simple', '1.6.6' ) }.must_raise RuntimeError
  end

  it 'warn on version conflict' do
    Jars.reset
    ENV['JARS_HOME'] = File.join( 'specs', 'repo' )

    require_jar( 'org.slf4j', 'slf4j-simple', '1.6.6' ).must_equal true
    $stderr = StringIO.new
    require_jar( 'org.slf4j', 'slf4j-simple', '1.6.4' ).must_equal false

    $stderr.string.must_equal "jar coordinate org.slf4j:slf4j-simple already loaded with version 1.6.6\n"

    $stderr = STDERR
    ENV['JARS_HOME'] = nil
  end

  it 'finds jars on the load_path' do
    Jars.reset
    $LOAD_PATH << File.join( 'specs', 'load_path' )
    ENV['JARS_HOME'] = 'something'
    $stderr = StringIO.new

    lambda { require_jar( 'org.slf4j', 'slf4j-simple', '1.6.6' ) }.must_raise RuntimeError

    $stderr.flush

    $stderr = StringIO.new
    require_jar( 'org.slf4j', 'slf4j-simple', '1.6.4' ).must_equal true

    require_jar( 'org.slf4j', 'slf4j-simple', '1.6.6' ).must_equal false

    $stderr.string.must_equal "jar coordinate org.slf4j:slf4j-simple already loaded with version 1.6.4\n"

    $stderr = STDERR
    ENV['JARS_HOME'] = nil
  end

  it 'freezes jar loading unless jar is not loaded yet' do
    begin
      Jars.reset

      size = $CLASSPATH.length

      Jars.freeze_loading

      require 'jopenssl/version'

      require_jar 'org.bouncycastle', 'bcpkix-jdk15on', Jopenssl::Version::BOUNCY_CASTLE_VERSION

      $CLASSPATH.length.must_equal size

      $stderr = StringIO.new

      require_jar 'org.bouncycastle', 'bcpkix-jdk15on', '1.46'

      $stderr.string.must_equal ''

      $stderr = STDERR

    rescue LoadError => e
      p e
      skip 'assume we have an old jruby'
    rescue NameError => e
      p e
      skip 'assume we have an old jruby'
    end
  end 

  it 'does not warn on conflicts after turning into silent mode' do
    begin
      Jars.reset

      # this might not even be true depending on how the classloader
      # names the loaded jars
      $CLASSPATH.detect { |c| c =~ /bouncycastle/ }.must_be_nil
      size = $CLASSPATH.length

      Jars.no_more_warnings

      require 'jopenssl/version'

      require_jar 'org.bouncycastle', 'bcpkix-jdk15on', Jopenssl::Version::BOUNCY_CASTLE_VERSION

      $CLASSPATH.length.must_equal (size + 1)

      $stderr = StringIO.new

      require_jar 'org.bouncycastle', 'bcpkix-jdk15on', '1.46'

      $stderr.string.must_equal ''

      $stderr = STDERR

    rescue LoadError => e
      p e
      skip 'assume we have an old jruby'
    rescue NameError => e
      p e
      skip 'assume we have an old jruby'
    end
  end 

  it 'no warnings on reload' do
    $stderr = StringIO.new

    load File.expand_path( 'lib/jar_dependencies.rb' )

    $stderr.string.must_equal ''

    $stderr = STDERR
  end
end
