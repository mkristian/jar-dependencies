require 'jar_dependencies'
module Jars
  class JarInstaller

    class Dependency
      
      attr_reader :path, :file, :gav, :scope, :type, :coord

      def self.new( line )
        if line.match /:jar:|:pom:/
          super
        end
      end

      def initialize( line )
        if line.match /:pom:/
          @type = :pom
        elsif line.match /:jar:/
          @type = :jar
        end
        line.sub!( /^\s+/, '' )
        @coord = line.sub( /:[^:]+:[^:]+$/, '' )
        first, second = line.sub( /:[^:]+:[^:]+$/, '' ).split( /:#{type}:/ )
        group_id, artifact_id = first.split( /:/ ) 
        parts = group_id.split( '.' ) 
        parts << artifact_id
        parts << second.split( /:/ )[ -1 ]
        parts << File.basename( line.sub /.:/, '' ) 
        @path = File.join( parts ).strip
        
        @scope = 
          case line
          when /:provided:/
            :provided
          when /:test:/
            :test
          else
            :runtime
          end
        line.gsub!( /:jar:|:pom:|:test:|:compile:|:runtime:|:provided:/, ':' )
        @file = line.sub( /^.*:/, '' ).strip
        @gav = line.sub( /:[^:]+$/, '' )
      end
    end

    def self.install_jars
      new.install_jars
    end

    def self.load_from_maven( file )
      result = []
      File.read( file ).each_line do |line|
        dep = Dependency.new( line )
        result << dep if dep
      end
      result
    end

    def self.write_require_file( require_filename )
      FileUtils.mkdir_p( File.dirname( require_filename ) )
      comment = '# this is a generated file, to avoid over-writing it just delete this comment'
      if ! File.exists?( require_filename ) || File.read( require_filename ).match( comment )
        f = File.open( require_filename, 'w' )
        f.puts comment
        f.puts "require 'jar_dependencies'"
        f.puts
        f
      end
    end

    def self.vendor_file( dir, dep )
      vendored = File.join( dir, dep.path )
      FileUtils.mkdir_p( File.dirname( vendored ) )
      FileUtils.cp( dep.file, vendored )
    end
    private :vendor_file

    def self.install_deps( deps, dir, require_filename, vendor )
      f = write_require_file( require_filename ) if require_filename
      deps.each do |dep|
        next if dep.type != :jar || dep.scope != :runtime
        args = dep.gav.gsub( /:/, "', '" )
        vendor_file( dir, dep ) if vendor
        f.puts( "require_jar( '#{args}' )" ) if f
      end
    ensure
      f.close if f
    end

    def find_spec
      specs = Dir[ '*.gemspec' ]
      case specs.size
      when 0
        raise 'no gemspec found'
      when 1
        specs.first
      else
        raise 'more then one gemspec found. please specify a specfile' 
      end
    end
    private :find_spec

    def initialize( spec = nil )
      spec ||= find_spec

      case spec
      when String
        @basedir = File.dirname( File.expand_path( spec ) )
        @specfile = spec
        spec =  eval( File.read( spec ) )
      else
        @basedir = spec.gem_dir
        @specfile = spec.spec_file
      end

      @spec = spec
    end

    def vendor_jars
      return if @spec.requirements.empty?
      really_vendor = Jars.to_prop( "JARS_VENDOR" ) || 'true'
      do_install( really_vendor == 'true', false )
    end

    def install_jars
      return if @spec.requirements.empty?
      do_install( false, true )
    end

    private

    def do_install( vendor, write_require_file )
      vendor_dir = File.join( @basedir, @spec.require_path )
      if write_require_file
        jars_file = File.join( vendor_dir, "#{@spec.name}_jars.rb" )

        # do not generate file if specfile is older then the generated file
        if File.exists?( jars_file ) && 
            File.mtime( @specfile ) < File.mtime( jars_file )
          jars_file = nil
        end
      end
      self.class.install_deps( install_dependencies, vendor_dir,
                               jars_file, vendor )
    end

    def setup_arguments( deps )
      args = [ 'dependency:list', "-DoutputFile=#{deps}", '-DincludeScope=runtime', '-DoutputAbsoluteArtifactFilename=true', '-DincludeTypes=jar', '-DoutputScope=true', '-f', @specfile ]
      
      verbose = Jars.to_prop( 'JARS_VERBOSE' ) == 'true'
      debug = Jars.to_prop( 'JARS_DEBUG' ) == 'true'

      if debug
        args << '-X'
      elsif ! verbose
        args << '--quiet'
      end

      args << "-Dmaven.repo.local=#{java.io.File.new( Jars.home ).absolute_path}"
      args
    end

    def lazy_load_maven
      require 'maven/ruby/maven'
    rescue LoadError
      raise "please install ruby-maven gem which is needed to install the jar dependencies\n\n\tgem install ruby-maven\n\n"
    end

    def monkey_path_gem_dependencies
      # monkey patch to NOT include gem dependencies
      require 'maven/tools/gemspec_dependencies'
      eval <<EOF
      class ::Maven::Tools::GemspecDependencies
        def runtime; []; end
        def development; []; end
      end
EOF
    end

    def install_dependencies
      lazy_load_maven
      
      monkey_path_gem_dependencies

      deps = File.join( @basedir, 'deps.lst' )

      maven = Maven::Ruby::Maven.new
      maven.exec( *setup_arguments( deps ) )

      self.class.load_from_maven( deps )
    ensure
      FileUtils.rm_f( deps ) if deps
    end
  end
end
