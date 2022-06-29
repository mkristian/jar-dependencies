# frozen_string_literal: true

require_relative '../../lib/jars/version'

# force to use prereleased gem
gem 'jar-dependencies', Jars::VERSION
require 'jar-dependencies'

require 'bundler/friendly_errors'
Bundler.with_friendly_errors do
  require 'bundler/cli'
  Bundler::CLI.start(ARGV, debug: true)
end
