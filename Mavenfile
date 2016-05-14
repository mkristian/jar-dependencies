#-*- mode: ruby -*-

gemfile

plugin_repository :id => :maven_gems, :url => 'mavengem:https://rubygems.org'

jruby_plugin( :minitest, :minispecDirectory => "specs/*_spec.rb" ) do
  execute_goals(:spec)
  gem 'ruby-maven', '${ruby-maven.version}'
end

# retrieve the ruby-maven version
gemfile_profile = @model.profiles.detect do |p|
  p.id.to_sym == :gemfile
end || @model
ruby_maven = gemfile_profile.dependencies.detect do |d|
  d.artifact_id == 'ruby-maven'
end

properties( 'jruby.versions' => ['1.7.12', '1.7.25', '${jruby.version}'
                                ].join(','),
            'jruby.modes' => ['1.9', '2.0', '2.2'].join(','),
            # just lock the version
            'bundler.version' => '1.10.6',
            'ruby-maven.version' => ruby_maven.version,
            'jruby.version' => '9.0.5.0',
            'jruby.plugins.version' => '1.1.3',
            'push.skip' => true  )

plugin :invoker, '1.8' do
  execute_goals( :install, :run,
                 :id => 'integration-tests',
                 :projectsDirectory => 'integration',
                 :streamLogs => true,
                 :goals => ['install'],
                 :preBuildHookScript => 'setup.bsh',
                 :postBuildHookScript => 'verify.bsh',
                 :cloneProjectsTo => '${project.build.directory}',
                 :properties => { 'jar-dependencies.version' => '${project.version}',
                   # use an old jruby with old ruby-maven here
                   'jruby.old-version' => '1.7.20',
                   'jruby.version' => '${jruby.version}',
                   'jruby.plugins.version' => '${jruby.plugins.version}',
                   'bundler.version' => '${bundler.version}',
                   'ruby-maven.version' => '${ruby-maven.version}' })
end

distribution_management do
  repository :id => :ossrh, :url => 'https://oss.sonatype.org/service/local/staging/deploy/maven2/'
end

profile :id => :skip do

 properties 'maven.test.skip' => true, 'invoker.skip' => true

end

profile :id => :release do
  properties 'maven.test.skip' => true, 'invoker.skip' => true, 'push.skip' => false

  build do
    default_goal :deploy
  end

end

# vim: syntax=Ruby
