require File.expand_path('setup', File.dirname(__FILE__))
require 'jar_installer'
require 'fileutils'
class Jars::JarInstaller
  def do_install( vendor, write )
    @vendor = vendor
    @write = write
  end

  attr_reader :vendor
  attr_reader :write
end
describe Jars::JarInstaller do

  let( :file ) { File.join( pwd, 'deps.txt' ) }

  let( :pwd ) { File.dirname( File.expand_path( __FILE__ ) ) }

  let( :dir ) { File.join( pwd, '..', 'pkg', 'tmp' ) }

  let( :jars ) { File.join( dir, 'test_jars.rb' ) }

  let( :example_spec ) { File.join( pwd, '..', 'example', 'example.gemspec' ) }

  before do
    FileUtils.rm_rf( dir )
    FileUtils.mkdir_p( dir )
  end

  it 'uses logging config' do
    jar = Jars::JarInstaller.new( example_spec )
    
    ENV[ 'JARS_VERBOSE' ] = nil
    ENV[ 'JARS_DEBUG' ] = nil
    args = jar.send :setup_arguments, "deps.file"
    args.member?( '--quiet' ).must_equal true
    args.member?( '-X' ).must_equal false

    ENV[ 'JARS_VERBOSE' ] = 'true'
    ENV[ 'JARS_DEBUG' ] = nil
    args = jar.send :setup_arguments, "deps.file"
    args.member?( '--quiet' ).must_equal false
    args.member?( '-X' ).must_equal false

    ENV[ 'JARS_VERBOSE' ] = nil
    ENV[ 'JARS_DEBUG' ] = 'true'
    args = jar.send :setup_arguments, "deps.file"
    args.member?( '--quiet' ).must_equal false
    args.member?( '-X' ).must_equal true

    ENV[ 'JARS_VERBOSE' ] = 'true'
    ENV[ 'JARS_DEBUG' ] = 'true'
    args = jar.send :setup_arguments, "deps.file"
    args.member?( '--quiet' ).must_equal false
    args.member?( '-X' ).must_equal true
  end

  it 'uses proxy settings from Gem.configuration' do
    ENV['JARS_MAVEN_SETTINGS'] = 'specs/does/no/exists/settings.xml'
    Jars.reset
    jar = Jars::JarInstaller.new( example_spec )
    
    Gem.configuration[ :proxy ] = 'https://localhost:3128'
    args = jar.send :setup_arguments, "deps.file"
    args.member?( '-DproxySet=true' ).must_equal true
    args.member?( '-DproxyHost=localhost' ).must_equal true
    args.member?( '-DproxyPort=3128' ).must_equal true

    Gem.configuration[ :proxy ] = :noproxy
    args = jar.send :setup_arguments, "deps.file"
    args.member?( '-DproxySet=true' ).must_equal false
    args.member?( '-DproxyHost=localhost' ).must_equal false
    args.member?( '-DproxyPort=3128' ).must_equal false

    ENV['JARS_MAVEN_SETTINGS'] = 'specs/settings.xml'
    Jars.reset
    Gem.configuration[ :proxy ] = 'https://localhost:3128'
    args = jar.send :setup_arguments, "deps.file"
    args.member?( '-DproxySet=true' ).must_equal false
    args.member?( '-DproxyHost=localhost' ).must_equal false
    args.member?( '-DproxyPort=3128' ).must_equal false
    
    ENV['JARS_MAVEN_SETTINGS'] = nil
    Jars.reset
  end

  it 'loads dependencies from maven' do
    deps = Jars::JarInstaller.load_from_maven( file )
    deps.size.must_equal 45
    deps.each { |d| d.must_be_kind_of Jars::JarInstaller::Dependency }
  end

  it 'generates non-vendored require-file' do
    deps = Jars::JarInstaller.load_from_maven( file )
    Jars::JarInstaller.install_deps( deps, dir, jars, false )
    File.read( jars ).each_line do |line|
      if line.size > 30 && !line.match( /^#/ )
        line.match( /^require_jar\(/ ).wont_be_nil
      end
    end
    Dir[ File.join( dir, '**' ) ].size.must_equal 1
  end

  it 'generates vendored require-file' do
    deps = Jars::JarInstaller.load_from_maven( file )
    Jars::JarInstaller.install_deps( deps, dir, jars, true )
    File.read( jars ).each_line do |line|
      if line.size > 30 && !line.match( /^#/ )
        line.match( /^require_jar\(/ ).wont_be_nil
      end
    end
    Dir[ File.join( dir, '**', '*.jar' ) ].size.must_equal 45
  end

  it 'just skips install_jars and vendor_jars if there are no requirements' do
    jar = Jars::JarInstaller.new
    jar.install_jars
    jar.vendor.must_be_nil
    jar.vendor_jars
    jar.vendor.must_be_nil
  end

  it 'does install_jars and vendor_jars' do
    ENV[ 'JARS_VENDOR' ] = nil
    jar = Jars::JarInstaller.new( example_spec )
    jar.install_jars
    jar.vendor.must_equal false
    jar.vendor_jars
    jar.vendor.must_equal true
    ENV[ 'JARS_VENDOR' ] = 'false'
    jar.vendor_jars
    jar.vendor.must_equal false
    ENV[ 'JARS_VENDOR' ] = 'true'
    jar.vendor_jars
    jar.vendor.must_equal true
    java.lang.System.set_property( 'jars.vendor', 'false' )
    jar.vendor_jars
    jar.vendor.must_equal false
  end

  it 'finds the gemspec file when the Gem::Specifiacation.spec_file is wrong' do
    spec = eval( File.read( example_spec ) )
    # mimic bundler case
    FileUtils.rm_f( spec.spec_file )
    def spec.gem_dir= d
      @d = d
    end
    def spec.gem_dir
      @d
    end
    spec.gem_dir = File.dirname( example_spec )
    # now test finding the gemspec file
    jar = Jars::JarInstaller.new( spec )
    jar.instance_variable_get( :@basedir ).must_equal File.expand_path( spec.gem_dir )
    jar.instance_variable_get( :@specfile ).must_equal File.expand_path( example_spec )
  end

  # do not run on travis due to random Errno::EBADF
  unless File.exists?( '/home/travis' )
    it 'installs dependencies ' do
      skip( "too many random Errno::EBADF" )
      ENV[ 'JARS_HOME' ] = dir
      jar = Jars::JarInstaller.new( example_spec )
      result = jar.send :install_dependencies
      result.size.must_equal 2
      result.each do |d|
        d.type.must_equal :jar
        d.scope.must_equal :runtime
      end
      ENV[ 'JARS_HOME' ] = nil
    end
  end
end
