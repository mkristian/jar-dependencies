require File.expand_path('setup', File.dirname(__FILE__))

require 'stringio'
describe Jars do
  @@_env_ = ENV.dup

  before do
    # helpful when debugging
    Jars.reset
  end

  after do
    Jars.reset
    ENV.clear; ENV.replace @@_env_ # restore ENV
  end

  it 'extract property' do
    ENV['SOME_JARS_HOME'] = 'bla'
    Jars.to_prop('some_jars_home').must_equal 'bla'
    if defined? JRUBY_VERSION
      java.lang.System.set_property('some.jars.home', 'blabla')
      Jars.to_prop('some_jars_home').must_equal 'blabla'
    end
  end

  it 'extract boolean property' do
    Jars.to_boolean('JARS_SOMETHING').must_equal nil

    ENV['JARS_SOMETHING'] = 'falsy'
    Jars.to_boolean('JARS_SOMETHING').must_equal false

    ENV[jars_verbose = 'JARS_VERBOSE'] = 'true'
    Jars.to_boolean(jars_verbose).must_equal true
    Jars.verbose?.must_equal true
    jars_verbose.must_equal 'JARS_VERBOSE' # no mod

    if defined? JRUBY_VERSION
      jars_skip = 'JARS_SKIP'
      begin
        java.lang.System.set_property('jars.skip', 'true')
        java.lang.System.set_property('jars.quiet', 'false')
        java.lang.System.set_property('jars.debug', '')

        Jars.to_boolean(jars_skip).must_equal true
        Jars.skip?.must_equal true
        jars_skip.must_equal 'JARS_SKIP' # no mod

        Jars.to_boolean('JARS_DEBUG').must_equal true
        Jars.to_boolean('jars.quiet').must_equal false
      ensure
        java.lang.System.clear_property('jars.skip')
        java.lang.System.clear_property('jars.quiet')
        java.lang.System.clear_property('jars.debug')
      end
    end
  end

  it 'extract maven settings' do
    settings = Jars.maven_settings
    settings&.sub(/.*\.m2./, '')&.must_equal 'settings.xml'

    ENV['JARS_MAVEN_SETTINGS'] = 'specs/settings.xml'
    Jars.reset
    settings.wont_equal Jars.maven_settings
    Jars.maven_settings.must_equal File.expand_path('specs/settings.xml')

    ENV['JARS_MAVEN_SETTINGS'] = nil

    Jars.reset
    Dir.chdir(File.dirname(__FILE__)) do
      settings.wont_equal Jars.maven_settings
      Jars.maven_settings.must_equal File.expand_path('settings.xml')
    end
  end

  it 'determines JARS_HOME' do
    ENV['M2_HOME'] = ENV['MAVEN_HOME'] = '' # so that it won't interfere
    ENV['JARS_QUIET'] = 'true'
    ENV['JARS_MAVEN_SETTINGS'] = 'does-not-exist/settings.xml'
    home = Jars.home
    home.must_equal(File.join(ENV['HOME'], '.m2', 'repository'))

    ENV['JARS_LOCAL_MAVEN_REPO'] = nil
    ENV['JARS_MAVEN_SETTINGS'] = File.join('specs', 'settings.xml')
    Jars.reset
    Jars.home.wont_equal home
    Jars.home.must_equal 'specs'

    ENV['JARS_MAVEN_SETTINGS'] = nil
  end

  it "determines JARS_HOME (when no ENV['HOME'] present)" do
    ENV['M2_HOME'] = ENV['MAVEN_HOME'] = '' # so that it won't interfere
    env_home = ENV['HOME']; ENV.delete('HOME')
    ENV['JARS_QUIET'] = true.to_s
    ENV['JARS_MAVEN_SETTINGS'] = 'does-not-exist/settings.xml'
    Jars.home.must_equal(File.join(env_home, '.m2', 'repository'))
  end

  it 'determines JARS_HOME (from global settings.xml)' do
    ENV['JARS_LOCAL_MAVEN_REPO'] = nil
    ENV['HOME'] = "/tmp/oul'bollocks!"
    ENV['M2_HOME'] = __dir__
    ENV_JAVA['repo.path'] = 'specs'
    Jars.home.must_equal('specs/repository')
    ENV['JARS_LOCAL_MAVEN_REPO'] = nil
  end

  it 'raises RuntimeError on requires of unknown jar' do
    -> { require_jar('org.something', 'slf4j-simple', '1.6.6') }.must_raise RuntimeError
  end

  it 'warn on version conflict' do
    ENV['JARS_HOME'] = File.join('specs', 'repo')
    Jars.reset

    begin
      require_jar('org.slf4j', 'slf4j-simple', '1.6.6').must_equal true
      $stderr = StringIO.new
      require_jar('org.slf4j', 'slf4j-simple', '1.6.4').must_equal false

      $stderr.string.must_equal "--- jar coordinate org.slf4j:slf4j-simple already loaded with version 1.6.6 - omit version 1.6.4\n"
    ensure
      $stderr = STDERR
      ENV['JARS_HOME'] = nil
    end
  end

  it 'finds jars on the load_path' do
    $LOAD_PATH << File.join('specs', 'load_path')
    ENV['JARS_HOME'] = 'something'
    Jars.reset

    begin
      $stderr = StringIO.new

      -> { require_jar('org.slf4j', 'slf4j-simple', '1.6.6') }.must_raise RuntimeError

      $stderr.flush

      $stderr = StringIO.new
      require_jar('org.slf4j', 'slf4j-simple', '1.6.4').must_equal true

      require_jar('org.slf4j', 'slf4j-simple', '1.6.6').must_equal false

      $stderr.string.must_equal "--- jar coordinate org.slf4j:slf4j-simple already loaded with version 1.6.4 - omit version 1.6.6\n"
    ensure
      $stderr = STDERR
      ENV['JARS_HOME'] = nil
    end
  end

  it 'freezes jar loading unless jar is not loaded yet' do
    begin
      size = $CLASSPATH.length

      Jars.freeze_loading

      require 'jopenssl/version'

      require_jar 'org.bouncycastle', 'bcpkix-jdk15on', Jopenssl::Version::BOUNCY_CASTLE_VERSION

      $CLASSPATH.length.must_equal size

      $stderr = StringIO.new

      require_jar 'org.bouncycastle', 'bcpkix-jdk15on', '1.46'

      $stderr.string.must_equal ''
    rescue LoadError => e
      p e
      skip 'assume we have an old jruby'
    rescue NameError => e
      p e
      skip 'assume we have an old jruby'
    ensure
      $stderr = STDERR
    end
  end

  it 'allows to programatically disable require_jar' do
    begin
      require 'jopenssl/version'

      size = $CLASSPATH.length

      Jars.require = false

      out = require_jar 'org.bouncycastle', 'bcpkix-jdk15on', Jopenssl::Version::BOUNCY_CASTLE_VERSION
      assert_nil out

      out = require_jar 'org.jruby', 'jruby-rack', '1.1.16'
      assert_nil out

      $CLASSPATH.length.must_equal size
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
      size = $CLASSPATH.length
      # TODO: use jline instead to avoid this skip
      if $CLASSPATH.detect { |a| a =~ /bcpkix-jdk15on/ } != nil
        skip('$CLASSPATH is not clean - need to skip spec')
      end

      Jars.no_more_warnings

      require 'jopenssl/version'

      if require_jar('org.bouncycastle', 'bcpkix-jdk15on', Jopenssl::Version::BOUNCY_CASTLE_VERSION)
        $CLASSPATH.length.must_equal (size + 1)
      end

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

    load File.expand_path('lib/jar_dependencies.rb')

    $stderr.string.must_equal ''

    $stderr = STDERR
  end

  it 'requires jars from various default places' do
    pwd = File.expand_path('..', __FILE__)
    $LOAD_PATH << File.join(pwd, 'path')

    $stderr = StringIO.new
    Dir.chdir(pwd) do
      require_jar 'more', 'sample', '4'
      require_jar 'more', 'sample', '2'
      require_jar 'more', 'sample', '3'
    end

    $stderr.string.wont_match /omit version 1/
    $stderr.string.must_match /omit version 2/
    $stderr.string.must_match /omit version 3/
    $stderr.string.wont_match /omit version 4/

    $stderr = STDERR

    $LOAD_PATH.delete(File.join(pwd, 'path'))
  end
end
