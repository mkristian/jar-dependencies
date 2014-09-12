#-*- mode: ruby -*-

gemfile

# TODO should be setup whenever a plugin uses gems
plugin_repository :id => 'rubygems-releases', :url => 'http://rubygems-proxy.torquebox.org/releases'

jruby_plugin( :minitest, :minispecDirectory => "specs/*_spec.rb" ) do
  execute_goals(:spec)
  gem 'ruby-maven', '3.1.1.0.8'
end

#snapshot_repository :jruby, 'http://ci.jruby.org/snapshots/maven'

# (jruby-1.6.8 mode 1.8 produces a lot of yaml errors parsing gemspecs)
properties( 'jruby.versions' => ['1.6.8', '1.7.13'#,'9000.dev-SNAPSHOT'
                                ].join(','),
            'jruby.modes' => ['1.9', '2.0','2.1'].join(','),
            # just lock the version
            'jruby.version' => '1.7.13',
            'tesla.dump.pom' => 'pom.xml',
            'tesla.dump.readonly' => true )

plugin :invoker, '1.8' do
  execute_goals( :install, :run,
                 :id => 'integration-tests',
                 :projectsDirectory => 'integration',
                 :properties => { 'jar-dependencies.version' => '${project.version}' },
                 :pomIncludes => [ '*/pom.xml' ],
                 :streamLogs => true )
end

# vim: syntax=Ruby
