#-*- mode: ruby -*-

gemfile

# TODO should be setup whenever a plugin uses gems
plugin_repository :id => 'rubygems-releases', :url => 'http://rubygems-proxy.torquebox.org/releases'

jruby_plugin( :minitest, :minispecDirectory => "specs/*_spec.rb" ) do
  execute_goals(:spec)
  gem 'ruby-maven', '3.1.1.0.8'
end

properties( 'jruby.versions' => ['1.7.12', '${jruby.version}', '9.0.0.0.pre1'
                                ].join(','),
            'jruby.modes' => ['1.9', '2.0', '2.1'].join(','),
            # just lock the version
            'jruby.version' => '1.7.19',
            'jruby.plugins.version' => '1.0.9',
            'tesla.dump.pom' => 'pom.xml',
            'tesla.dump.readonly' => true )

plugin :invoker, '1.8' do
  execute_goals( :install, :run,
                 :id => 'integration-tests',
                 :projectsDirectory => 'integration',
                 :streamLogs => true,
                 :goals => ['install'],
                 :cloneProjectsTo => '${project.build.directory}',
                 :properties => { 'jar-dependencies.version' => '${project.version}',
                   'jruby.version' => '${jruby.version}',
                   'jruby.plugins.version' => '${jruby.plugins.version}',
                   'bundler.version' => '1.9.2',
                   'ruby-maven.version' => '3.1.1.0.11',
                   # dump pom for the time being - for travis
                   'polyglot.dump.pom' => 'pom.xml'})
end

# vim: syntax=Ruby
