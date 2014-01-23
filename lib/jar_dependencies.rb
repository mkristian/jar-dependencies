def require_jar( groupId, artifactId, version, classifier = nil )
  name = "#{groupId}/#{artifactId}-#{version}"
  name += "-#{classifier}" if classifier
  require_jarfile( "#{name}.jar", groupId, artifactId, version, classifier )
end

def require_jarfile( file, groupId, artifactId, version, classifier = nil )
  skip = java.lang.System.get_property( 'jruby.skip.jars' ) || ENV[ 'JRUBY_SKIP_JARS' ]
  return false if skip == 'true'
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
