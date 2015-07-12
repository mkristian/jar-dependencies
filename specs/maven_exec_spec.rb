require File.expand_path('setup', File.dirname(__FILE__))

require 'jars/maven_exec'
require 'fileutils'

describe Jars::MavenExec do

  let( :pwd ) { File.dirname( File.expand_path( __FILE__ ) ) }

  let( :example_spec ) { File.join( pwd, '..', 'example', 'example.gemspec' ) }

  after do
    Jars.reset
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
