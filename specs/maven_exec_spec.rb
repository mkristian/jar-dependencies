require_relative 'setup'
require 'jars/maven_exec'
require 'fileutils'

describe Jars::MavenExec do

  let( :pwd ) { File.dirname( File.expand_path( __FILE__ ) ) }

  let( :example_spec ) { File.join( pwd, '..', 'example', 'example.gemspec' ) }

  after do
    ENV[ 'JARS_VERBOSE' ] = nil
    ENV[ 'JARS_DEBUG' ] = nil
    ENV[ 'JARS_MAVEN_SETTINGS' ] = nil
    Jars.reset
  end

  it 'uses logging config' do
    jar = Jars::MavenExec.new( example_spec )
    
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
    jar = Jars::MavenExec.new( example_spec )
    
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
  end

  it 'finds the gemspec file when the Gem::Specifiacation.spec_file is wrong' do
    spec = Dir.chdir( File.dirname( example_spec ) ) do
      eval( File.read( example_spec ) )
    end

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
    jar = Jars::MavenExec.new( spec )
    jar.instance_variable_get( :@basedir ).must_equal File.expand_path( spec.gem_dir )
    jar.instance_variable_get( :@specfile ).must_equal File.expand_path( example_spec )
  end
end
