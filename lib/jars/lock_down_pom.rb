# this file is maven DSL and used by maven via jars/lock_down.rb

basedir( ENV_JAVA[ "jars.basedir" ] )

load File.join( File.dirname(__FILE__), 'attach_jars_pom.rb' )

jfile = ENV_JAVA[ "jars.jarfile" ]
jarfile( jfile ) if jfile


# if you use bundler we collect all root jar dependencies
# from each gemspec file. otherwise we need to resolve
# the gemspec artifact in the maven way
unless ENV_JAVA[ "jars.bundler" ]

  jruby_plugin :gem, ENV_JAVA[ "jruby.plugins.version" ]

  gemspec rescue nil

end

properties( 'project.build.sourceEncoding' => 'utf-8' )

plugin :dependency, ENV_JAVA[ "dependency.plugin.version" ]

load File.join( File.dirname(__FILE__), 'output_jars_pom.rb' )
