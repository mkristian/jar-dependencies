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

def require_jar( groupId, artifactId, *classifier_version )
  require_jarfile( nil, groupId, artifactId, *classifier_version )
end

def require_jarfile( file, groupId, artifactId, *classifier_version )
  skip = java.lang.System.get_property( 'jruby.skip.jars' ) || ENV[ 'JRUBY_SKIP_JARS' ] || java.lang.System.get_property( 'jbundler.skip' ) || ENV[ 'JBUNDLER_SKIP' ]
  return false if skip == 'true'

  if classifier_version.size == 1
    version = classifier_version[ 0 ]
    classifier = nil
  else
    version = classifier_version[ 1 ]
    classifier = classifier_version[ 0 ]
  end

  # if no file given than it is vendored
  # if the file does not exists we assume it is vendored
  if file.nil? || !File.exists?( file )
    file = "#{groupId}/#{artifactId}-#{version}"
    file += "-#{classifier}" if classifier
    file += '.jar'
  end

  @@jars ||= {}
  coordinate = "#{groupId}:#{artifactId}"
  coordinate += ":#{classifier}" if classifier
  if @@jars.key? coordinate
    if @@jars[ coordinate ] != version
      warn "coordinate #{coordinate} already loaded with version #{@@jars[ coordinate ]}"
    end
    false
  else
    begin
      if require file
        @@jars[ coordinate ] = version
        true
      else
        raise LoadError.new( "coordindate #{coordinate} not found" )
      end
    rescue LoadError => e
      warn 'you might need to restall that gem which needs the missing jar'
      raise e
    end
  end
end
