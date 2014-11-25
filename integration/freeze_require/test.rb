#-*- mode: ruby -*-

require 'jar-dependencies'

Jars.freeze_loading

raise 'no env variable for freeze' if ENV[Jars::NO_REQUIRE]

begin

  require 'openssl'

  raise 'load error expected'

rescue LoadError
end

# vim: syntax=Ruby
