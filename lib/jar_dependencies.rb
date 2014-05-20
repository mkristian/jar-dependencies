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
  HOME = 'JARS_HOME'
  MAVEN_SETTINGS = 'JARS_MAVEN_SETTINGS'

  if defined? JRUBY_VERSION
    def self.to_prop( key )
      java.lang.System.getProperty( key.downcase.gsub( /_/, '.' ) ) ||
        ENV[key.upcase.gsub( /[.]/, '_' ) ]
    end
  else
    def self.to_prop( key )
      ENV[ key.upcase.gsub( /[.]/, '_' ) ]
    end
  end

  def self.absolute( file )
    File.expand_path( file ) if file
  end

  def self.maven_settings
    if @_jars_maven_settings_.nil?
      unless @_jars_maven_settings_ = absolute( to_prop( MAVEN_SETTINGS ) )
        # use maven default settings
        @_jars_maven_settings_ = File.join( ENV[ 'HOME' ], 
                                            '.m2', 'settings.xml' )
      end
    end
    @_jars_maven_settings_
  end

  def self.home
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
      @_jars_home_ ||= File.join( ENV[ 'HOME' ], '.m2', 'repository' )
    end
    @_jars_home_
  end

  def self.require_jar( group_id, artifact_id, *classifier_version )
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
      @@jars[ coordinate ] = version
      do_require( group_id, artifact_id, version, classifier )
    end
  end

  private

  def self.to_jar( group_id, artifact_id, version, classifier )
    file = "#{group_id.gsub( /\./, '/' )}/#{artifact_id}/#{version}/#{artifact_id}-#{version}"
    file += "-#{classifier}" if classifier
    file += '.jar'
    file
  end

  def self.do_require( *args )
    jar = to_jar( *args )
    file = File.join( home, jar )
    # use jar from local repository if exists
    if File.exists?( file )
      require file
    else
      # otherwise try to find it on the load path
      require jar
    end
  end
end

def require_jar( *args )
  result = Jars.require_jar( *args )
  if result.is_a? String
    warn "jar coordinate #{args.join( ':' )} already loaded with version #{result}"
    return false
  end
  result
rescue LoadError => e
  warn 'you might need to reinstall the gem which depends on the missing jar.'
  raise e
end
