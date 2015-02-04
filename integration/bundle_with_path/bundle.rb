
spec = eval( File.read( File.expand_path('../../../jar-dependencies.gemspec', __FILE__ ) ) )

# force to use prereleased gem
gem 'jar-dependencies', spec.version
require 'jar-dependencies'

require 'bundler/friendly_errors'
Bundler.with_friendly_errors do
  require 'bundler/cli'
  Bundler::CLI.start(ARGV, :debug => true)
end
