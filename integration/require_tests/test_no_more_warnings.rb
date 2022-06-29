# frozen_string_literal: true

require 'jar-dependencies'

Jars.no_more_warnings

raise 'expected no env variable for freeze' if ENV[Jars::NO_REQUIRE]

raise 'expected no bouncycastle jars in classpath' if $CLASSPATH.detect { |c| c.include?('bouncycastle') }

require 'openssl'

raise 'did not find bouncycastle jars' unless $CLASSPATH.detect { |c| c.include?('bouncycastle') }

$stderr = StringIO.new

require_jar 'org.bouncycastle', 'bcpkix-jdk15on', '1.46'

raise 'no warning on jar conflics after freeze' unless $stderr.string.empty?

$stderr = STDERR
