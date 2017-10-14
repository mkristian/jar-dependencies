#-*- mode: ruby -*-

require 'jar-dependencies'

Jars.no_more_warnings

raise 'expected no env variable for freeze' if ENV[Jars::NO_REQUIRE]

if $CLASSPATH.detect { |c| c =~ /bouncycastle/ }
  raise 'expected no bouncycastle jars in classpath'
end

require 'openssl'

unless $CLASSPATH.detect { |c| c =~ /bouncycastle/ }
  raise 'did not find bouncycastle jars'
end

$stderr = StringIO.new

require_jar 'org.bouncycastle', 'bcpkix-jdk15on', '1.46'

raise 'no warning on jar conflics after freeze' unless $stderr.string.empty?

$stderr = STDERR

# vim: syntax=Ruby
