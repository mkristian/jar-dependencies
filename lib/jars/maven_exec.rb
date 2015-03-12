require 'jar_dependencies'
require 'uri'
module Jars
  class MavenExec

    def find_spec( allow_no_file )
      specs = Dir[ '*.gemspec' ]
      case specs.size
      when 0
        raise 'no gemspec found' unless allow_no_file
      when 1
        specs.first
      else
        raise 'more then one gemspec found. please specify a specfile' unless allow_no_file
      end
    end
    private :find_spec

    attr_reader :basedir, :spec, :specfile

    def initialize( spec = nil )
      setup( spec )
    end

    def setup( spec = nil, allow_no_file = false )
      spec ||= find_spec( allow_no_file )

      case spec
      when String
        @specfile = File.expand_path( spec )
        @basedir = File.dirname( @specfile )
        spec =  eval( File.read( spec ) )
      when Gem::Specification
        if File.exists?( spec.spec_file )
          @basedir = spec.gem_dir
          @specfile = spec.spec_file
        else
          # this happens with bundle and local gems
          # there the spec_file is "not installed" but inside
          # the gem_dir directory
          Dir.chdir( spec.gem_dir ) do
            setup( nil, true )
          end
        end
      when NilClass
      else
        raise 'spec must be either String or Gem::Specification'
      end

      @spec = spec
    rescue
      # for all those strange gemspec we skip looking for jar-dependencies
    end

    def ruby_maven_install_options=( options )
      @options = options.dup
      @options.delete( :ignore_dependencies )
    end

    def resolve_dependencies( file )
      lazy_load_maven

      maven = Maven::Ruby::Maven.new
      maven.verbose = Jars.verbose?
      maven.exec( *setup_arguments( file ) )
    end

    private

    def setup_arguments( deps )
      if File.basename( deps ) == 'Jars.lock'
        pom = 'jars_lock_pom.rb'
        goals = [ 'dependency:copy-dependencies' ]
      else
        pom = 'jar_pom.rb'
        goals = [ 'dependency:copy-dependencies', 'dependency:list' ]
      end
      args = [ *goals,
               "-DoutputFile=#{deps}", 
               '-DoutputAbsoluteArtifactFilename=true', 
               '-DincludeTypes=jar', 
               '-DoutputScope=true',
               '-DuseRepositoryLayout=true',
               "-DoutputDirectory=#{Jars.home}",
               '-f', File.dirname( __FILE__ ) + '/' + pom,
               "-Djars.specfile=#{@specfile}" ]

      if Jars.debug?
        args << '-X'
      elsif not Jars.verbose?
        args << '--quiet'
      end

      if Jars.maven_user_settings.nil? && (proxy = Gem.configuration[ :proxy ]).is_a?( String )
        uri = URI.parse( proxy )
        args << "-DproxySet=true"
        args << "-DproxyHost=#{uri.host}"
        args << "-DproxyPort=#{uri.port}"
      end

      if defined? JRUBY_VERSION
        args << "-Dmaven.repo.local=#{java.io.File.new( Jars.home ).absolute_path}"
      else
        args << "-Dmaven.repo.local=#{File.expand_path( Jars.home )}"
      end

      args
    end

    def lazy_load_maven
      require 'maven/ruby/maven'
    rescue LoadError
      install_ruby_maven
      require 'maven/ruby/maven'
    end

    def install_ruby_maven
      require 'rubygems/dependency_installer'
      jars = Gem.loaded_specs[ 'jar-dependencies' ]
      dep = jars.dependencies.detect { |d| d.name == 'ruby-maven' }
      req = dep.nil? ? Gem::Requirement.create( '>0' ) : dep.requirement
      inst = Gem::DependencyInstaller.new( @options || {} )
      inst.install 'ruby-maven', req
    rescue => e
      warn e.backtrace.join( "\n" ) if Jars.verbose?
      raise "there was an error installing 'ruby-maven'. please install it manually: #{e.inspect}"
    end
  end
end
