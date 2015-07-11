# this file is maven DSL and used by maven via jars/executor.rb

bdir = ENV_JAVA[ "jars.basedir" ]
jfile = ENV_JAVA[ "jars.jarfile" ]

basedir( bdir )
if basedir != bdir
  # older maven-tools needs this
  self.instance_variable_set( :@basedir, bdir )
end

( 0..10000 ).each do |i|
  coord = ENV_JAVA[ "jars.#{i}" ]
  break unless coord
  artifact = Maven::Tools::Artifact.from_coordinate( coord )
  exclusions = []
  ( 0..10000 ).each do |j|
    exclusion = ENV_JAVA[ "jars.#{i}.exclusion.#{j}" ]
    break unless exclusion
    exclusions << exclusion
  end
  artifact.exclusions = exclusions unless exclusions.empty?
  scope = ENV_JAVA[ "jars.#{i}.scope" ]
  artifact.scope = scope if scope
  dependency_artifact( artifact ) 
end

jarfile( jfile )

properties( 'project.build.sourceEncoding' => 'utf-8' )

jruby_plugin :gem, ENV_JAVA[ "jruby.plugins.version" ]

plugin :dependency, ENV_JAVA[ "dependency.plugin.version" ]

# some output
model.dependencies.each do |d|
  puts "      " + d.group_id + ':' + d.artifact_id + (d.classifier ? ":" + d.classifier : "" ) + ":" + d.version + ':' + (d.scope || 'compile')
end
