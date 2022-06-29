# frozen_string_literal: true

require_relative '../../../lib/jars/version'

# force to use prereleased gem
gem 'jar-dependencies', Jars::VERSION
require 'jar-dependencies'

Gem.install(File.expand_path('../gem/pkg/with-system-jar-1.1.1.gem', __dir__))

require 'first'

raise "missing tools.jar, not found in #{$CLASSPATH.inspect}" unless $CLASSPATH.detect { |c| c =~ /tools.jar/ }
