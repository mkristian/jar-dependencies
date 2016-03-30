require File.expand_path('setup', File.dirname(__FILE__))

require 'jars/maven_exec'
require 'fileutils'

describe Jars::MavenExec do

  let( :pwd ) { File.dirname( File.expand_path( __FILE__ ) ) }

  let( :example_spec ) { File.join( pwd, '..', 'example', 'example.gemspec' ) }
  let( :spec_with_require_relative ) { File.join( pwd, 'example', 'gem_with_require_relative', 'gem_with_require_relative.gemspec' ) }

  after do
    Jars.reset
  end

  it 'should not warn if gemspec contains require_relative' do
    Dir.chdir ( File.dirname ( spec_with_require_relative ) ) do
      begin
        $stderr = StringIO.new
        jar = Jars::MavenExec.new( )
        $stderr.string.must_equal ''
      ensure
        $stderr = STDERR
      end
    end
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
