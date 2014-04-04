require 'setup'
require 'jar_installer'
require 'fileutils'
class JarInstaller
  def do_install( vendor )
    @vendor = vendor
  end

  attr_reader :vendor
end
describe JarInstaller do

  let( :file ) { File.join( pwd, 'deps.txt' ) }

  let( :pwd ) { File.dirname( File.expand_path( __FILE__ ) ) }
  
  let( :dir ) { File.join( pwd, '..', 'pkg', 'tmp' ) }

  let( :jars ) { File.join( dir, 'test_jars.rb' ) }

  let( :example_spec ) { File.join( pwd, '..', 'example', 'example.gemspec' ) }
 
  before do 
    FileUtils.rm_rf( dir )
    FileUtils.mkdir_p( dir )
  end

  it 'loads dependencies from maven' do
    deps = JarInstaller.load_from_maven( file )
    deps.size.must_equal 45
    deps.each { |d| d.must_be_kind_of JarInstaller::Dependency }
  end

  it 'generates non-vendored require-file' do
    deps = JarInstaller.load_from_maven( file )
    JarInstaller.install_deps( deps, dir, jars, false )
    File.read( jars ).each_line do |line|
      if line.size > 30
        line.match( /^require_jarfile\(/ ).wont_be_nil
      end
    end
    Dir[ File.join( dir, '**' ) ].size.must_equal 1
  end

  it 'generates vendored require-file' do
    deps = JarInstaller.load_from_maven( file )
    JarInstaller.install_deps( deps, dir, jars, true )
    File.read( jars ).each_line do |line|
      if line.size > 30
        line.match( /^require_jar\(/ ).wont_be_nil
      end
    end
    Dir[ File.join( dir, '**', '*.jar' ) ].size.must_equal 45
  end

  it 'just skips install_jars and vendor_jars if there are no requirements' do
    jar = JarInstaller.new
    jar.install_jars
    jar.vendor.must_be_nil
    jar.vendor_jars
    jar.vendor.must_be_nil
  end

  it 'does install_jars and vendor_jars' do
    jar = JarInstaller.new( example_spec )
    jar.install_jars
    jar.vendor.must_equal false
    jar.vendor_jars
    jar.vendor.must_equal true
    ENV[ 'JRUBY_JARS_VENDOR' ] = 'false'
    jar.vendor_jars
    jar.vendor.must_equal false
    ENV[ 'JRUBY_JARS_VENDOR' ] = 'true'
    jar.vendor_jars
    jar.vendor.must_equal true
    java.lang.System.set_property( 'jruby.jars.vendor', 'false' )
    jar.vendor_jars
    jar.vendor.must_equal false
  end

  it 'installs dependencies ' do
    jar = JarInstaller.new( example_spec )
    result = jar.send :install_dependencies
    result.size.must_equal 2
    result.each do |d| 
      d.type.must_equal :jar
      d.scope.must_equal :runtime
    end
  end
end
