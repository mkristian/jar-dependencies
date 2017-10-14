unless defined? Jars
  # trigger to require of Jars.lock
  require 'leafy-metrics'
end

raise "wrong number of entries in classpath #{$CLASSPATH}" if $CLASSPATH.size != 5
