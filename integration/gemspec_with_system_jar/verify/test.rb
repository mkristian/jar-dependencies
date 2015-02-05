#-*- mode: ruby -*-

spec = eval( File.read( File.expand_path('../../../../jar-dependencies.gemspec', __FILE__ ) ) )

# force to use prereleased gem
gem 'jar-dependencies', spec.version
require 'jar-dependencies'

Gem.install( File.expand_path( "../../gem/pkg/first-1.1.1.gem", __FILE__ ) )

require "first"

raise "missing tools.jar" unless $CLASSPATH.detect { |c| c =~ /tools.jar/ }

# vim: syntax=Ruby
