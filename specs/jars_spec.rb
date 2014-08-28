require_relative 'setup'
require 'jar_dependencies'
require 'stringio'
describe Jars do

  @@_env_ = ENV.dup

  before do
    Jars.reset
  end

  after do
    ENV.replace @@_env_ # restore ENV
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

    ENV['JARS_MAVEN_SETTINGS'] = 'settings.xml'
    Jars.reset
    settings.wont_equal Jars.maven_settings
    Jars.maven_settings.must_equal File.expand_path( 'settings.xml' )
    ENV['JARS_MAVEN_SETTINGS'] = nil
  end

  it 'determines JARS_HOME' do
    ENV['JARS_MAVEN_SETTINGS'] = 'settings.xml'
    home = Jars.home
    home.must_equal( File.join( ENV[ 'HOME' ], '.m2', 'repository' ) )

    ENV['JARS_MAVEN_SETTINGS'] = File.join( 'specs', 'settings.xml' )
    Jars.reset
    Jars.home.wont_equal home
    Jars.home.must_equal "/usr/local/repository"

    ENV['JARS_MAVEN_SETTINGS'] = nil
  end

  it "determines JARS_HOME (when no ENV['HOME'] present)" do
    env_home = ENV[ 'HOME' ]
    ENV.delete('HOME')
    ENV['JARS_MAVEN_SETTINGS'] = 'settings.xml'
    home = Jars.home
    home.must_equal( File.join( env_home, '.m2', 'repository' ) )
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
end
