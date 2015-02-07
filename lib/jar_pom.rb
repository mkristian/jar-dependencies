# this file is maven DSL and used by maven via jar_installer.rb

specfile = java.lang.System.getProperty('jars.specfile')

# needed since the gemspec does not allow absolute files
basedir( File.dirname( specfile ) )

# get ALL depenedencies from the specfile
gemspec File.basename( specfile )

# we do not want those gem dependencies
model.dependencies.each do |d|
  model.dependencies.remove( d ) if d.group_id == 'rubygems'
end

# some output
model.dependencies.each do |d|
  puts "      " + d.group_id + ':' + d.artifact_id + (d.classifier ? ":" + d.classifier : "" ) + ":" + d.version
end
