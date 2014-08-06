require 'bundler/setup'
Bundler.setup

require 'rspec'

# loads all dependent jars and exmaple.jar
require 'example'

RSpec.configure do |config|
  config.order = "random"
end
