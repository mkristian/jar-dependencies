#-*- mode: ruby -*-

file = File.expand_path('../../../../jar-dependencies.gemspec', __FILE__)
spec = Dir.chdir(File.dirname(file)) do
  eval(File.read(file))
end

# force to use prereleased gem
gem 'jar-dependencies', spec.version
require 'jar-dependencies'

Gem.install(File.expand_path('../../gem/pkg/with-system-jar-1.1.1.gem', __FILE__))

require 'first'

raise "missing tools.jar, not found in #{$CLASSPATH.inspect}" unless $CLASSPATH.detect { |c| c =~ /tools.jar/ }

# vim: syntax=Ruby
