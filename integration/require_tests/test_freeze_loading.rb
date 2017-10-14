#-*- mode: ruby -*-

require 'jar-dependencies'

Jars.freeze_loading

raise 'expected no env variable for freeze' if ENV[Jars::NO_REQUIRE]

if $CLASSPATH.detect { |c| c =~ /bouncycastle/ }
  raise 'expected no bouncycastle jars in classpath'
end

begin
  require 'openssl'

  raise 'expected LoadError'
rescue LoadError
end

# vim: syntax=Ruby
