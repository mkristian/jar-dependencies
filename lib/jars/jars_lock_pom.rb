# this file is maven DSL and used by maven via jars/maven_exec.rb

require_relative 'lock'
require_relative '../jar_dependencies'

lock = Jars::Lock.new( java.lang.System.getProperty('outputFile') )

lock.process( :all ) do |coord|

  options = { :scope => coord.scope }
  options[ :systemPath ] = coord[ -1 ] if coord.scope == :system
  options[ :classifier ] = coord.classifier
  
  jar coord.group_id, coord.artifact_id, coord.version, options

end

properties :excludeTransitive => true
