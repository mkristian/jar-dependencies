#
# Copyright (C) 2014 Christian Meier
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

module Jars
  HOME = 'JARS_HOME'.freeze
  MAVEN_SETTINGS = 'JARS_MAVEN_SETTINGS'.freeze
  SKIP = 'JARS_SKIP'.freeze
  NO_REQUIRE = 'JARS_NO_REQUIRE'.freeze
  QUIET = 'JARS_QUIET'.freeze
  VERBOSE = 'JARS_VERBOSE'.freeze
  DEBUG = 'JARS_DEBUG'.freeze
  VENDOR = 'JARS_VENDOR'.freeze

  class << self

    if defined? JRUBY_VERSION
      def to_prop( key )
        java.lang.System.getProperty( key.downcase.gsub( /_/, '.' ) ) ||
          ENV[ key.upcase.gsub( /[.]/, '_' ) ]
      end
    else
      def to_prop( key )
        ENV[ key.upcase.gsub( /[.]/, '_' ) ]
      end
    end

    def to_boolean( key )
      prop = to_prop( key )
      # prop == nil => false
      # prop == 'false' => false
      # anything else => true
      prop == '' or prop == 'true'
    end

    def skip?
      to_boolean( SKIP )
    end

    def no_require?
      to_boolean( NO_REQUIRE )
    end

    def quiet?
      to_boolean( QUIET )
    end

    def verbose?
      to_boolean( VERBOSE )
    end

    def debug?
      to_boolean( DEBUG )
    end

    def vendor?
      to_boolean( VENDOR )
    end

    def freeze_loading
      ENV[ NO_REQUIRE ] = 'true'
    end

    def reset
      @_jars_maven_settings_ = nil
      @_jars_home_ = nil
      @@jars ||= {}
      @@jars.clear
    end

    def maven_settings
      if @_jars_maven_settings_.nil?
        unless @_jars_maven_settings_ = absolute( to_prop( MAVEN_SETTINGS ) )
          # use maven default settings
          @_jars_maven_settings_ = File.join( user_home, '.m2', 'settings.xml' )
        end
      end
      @_jars_maven_settings_
    end

    def home
      if @_jars_home_.nil?
        unless @_jars_home_ = absolute( to_prop( HOME ) )
          begin
            require 'rexml/document'
            doc = REXML::Document.new( File.read( maven_settings ) )
            REXML::XPath.first( doc, "//settings/localRepository").tap do |e|
              @_jars_home_ = e.text.sub( /\\/, '/') if e
            end
          rescue
            # ignore
          end
        end
        # use maven default repository
        @_jars_home_ ||= File.join( user_home, '.m2', 'repository' )
      end
      @_jars_home_
    end

    def require_jar( group_id, artifact_id, *classifier_version )
      version = classifier_version[ -1 ]
      classifier = classifier_version[ -2 ]

      @@jars ||= {}
      coordinate = "#{group_id}:#{artifact_id}"
      coordinate += ":#{classifier}" if classifier
      if @@jars.key? coordinate
        if @@jars[ coordinate ] == version
          false
        else
          # version of already registered jar
          @@jars[ coordinate ]
        end
      else
        do_require( group_id, artifact_id, version, classifier )
        @@jars[ coordinate ] = version
        return true
      end
    end

    private


    def absolute( file )
      File.expand_path( file ) if file
    end

    def user_home
      ENV[ 'HOME' ] || begin
        user_home = Dir.home if Dir.respond_to?(:home)
        unless user_home
          user_home = ENV_JAVA[ 'user.home' ] if Object.const_defined?(:ENV_JAVA)
        end
        user_home
      end
    end

    def to_jar( group_id, artifact_id, version, classifier )
      file = "#{group_id.gsub( /\./, '/' )}/#{artifact_id}/#{version}/#{artifact_id}-#{version}"
      file << "-#{classifier}" if classifier
      file << '.jar'
      file
    end

    def do_require( *args )
      jar = to_jar( *args )
      file = File.join( home, jar )
      # use jar from local repository if exists
      if File.exists?( file )
        require file
      else
        # otherwise try to find it on the load path
        require jar
      end
    rescue LoadError => e
      raise "\n\n\tyou might need to reinstall the gem which depends on the missing jar\n\n" + e.message + " (LoadError)"
    end

  end # class << self

end

def require_jar( *args )
  return false if Jars.no_require?
  result = Jars.require_jar( *args )
  if result.is_a? String
    warn "jar coordinate #{args[0..-2].join( ':' )} already loaded with version #{result}" unless Jars.quiet?
    return false
  end
  result
end
