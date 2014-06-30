#-*- mode: ruby -*-

gemfile

jruby_plugin( :minitest, :minispecDirectory => "specs/*_spec.rb" ) do
  execute_goals(:spec)
end

snapshot_repository :jruby, 'http://ci.jruby.org/snapshots/maven'

# (jruby-1.6.8 produces a lot of yaml errors parsing gemspecs)
properties( 'jruby.versions' => ['1.6.8', '1.7.13','9000.dev-SNAPSHOT'].join(','),
            'jruby.modes' => ['1.9', '2.0','2.1'].join(','),
            # just lock the version
            'jruby.version' => '1.7.13',
            'tesla.dump.pom' => 'pom.xml',
            'tesla.dump.readonly' => true )

# vim: syntax=Ruby
