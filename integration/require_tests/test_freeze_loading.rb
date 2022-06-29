# frozen_string_literal: true

require 'jar-dependencies'

Jars.freeze_loading

raise 'expected no env variable for freeze' if ENV[Jars::NO_REQUIRE]

raise 'expected no bouncycastle jars in classpath' if $CLASSPATH.detect { |c| c.include?('bouncycastle') }

begin
  require 'openssl'

  raise 'expected LoadError'
rescue LoadError
  # expected
end
