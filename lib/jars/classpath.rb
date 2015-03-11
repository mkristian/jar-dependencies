require 'jars/maven_exec'

module Jars
  class JarDetails < Array
    def scope
      self[ -2 ]
    end

    def file
      self[ -1 ]
    end

    def group_id
      self[ 0 ]
    end
    
    def artifact_id
      self[ 1 ]
    end

    def version
      self[ -3 ]
    end

    def classifier
      size == 5 ? nil : self[ 2 ]
    end

    def gacv
      size = 5 ? self[ 0..2 ] : self[ 0..3 ]
    end
  end

  class Classpath

    def initialize
      @mvn = MavenExec.new
    end

    def workdir( dirname )
      dir = File.join( @mvn.basedir, dirname )
      dir if File.dir?( dir )
    end

    def jars_lock
      return unless @mvn.basedir
      deps = File.join( @mvn.basedir, 'Jars.lock' )
      deps if File.exists?( deps )
    end

    def dependencies_list
      deps = self.class.jars_lock
      if File.exists?( deps )
        deps
      else
        resolve_dependencies
      end
    end
    private :dependencies_list

    def resolve_dependencies
      basedir = workdir( 'pkg' ) || workdir( 'target' ) || workdir( '' )
      deps = File.join( basedir, 'dependencies.list' )
      
      @mvn.resolve_dependencies( deps )
      deps
    end
    private :resolve_dependencies

    def require( scope = :compile )
      process( scope ) do |jar|
        require_jar( *jar.gacv )
      end
    end

    def classpath( scope = :compile )
      classpath = []
      process( scope ) do |jar|
        classpath << jar.file
      end
      classpath
    end

    def process( scope )
      deps = dependencies_list
      File.read( deps ).each_line do |line|
        next if not line =~ /^\s+/ or line == "\n"
        jar = JarDetails.new( line.strip.split( /:/ ) )
        case scope
        when :compile
          yield jar if jar.scope != 'test'
        when :runtime
          yield jar if jar.scope == 'compile' || jar.scope == 'runtime'
        when :test
          yield jar if jar.scope != 'runtime'
        end
      end
    ensure
      FileUtils.rm_f( deps )
    end
    private :process

    def classpath_string( scope = :runtime )
      classpath( scope ).join( File::PATH_SEPARATOR )
    end
  end
end
