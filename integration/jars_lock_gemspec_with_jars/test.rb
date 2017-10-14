unless defined? Jars
  require 'jar-dependencies'
  # trigger to require of Jars.lock
  require_jar('org.apache.hbase', 'hbase-annotations', '0.98.7-hadoop2')
end

['hbase-annotations-0.98.7-hadoop2.jar', '/tools.jar', 'findbugs-annotations-1.3.9-1.jar', 'log4j-1.2.17.jar'].each do |jar|
  raise "missing #{jar}" unless $CLASSPATH.detect { |c| c =~ /#{jar}/ }
end

raise "too many entries in classpath #{$CLASSPATH}" if $CLASSPATH.size != 4
