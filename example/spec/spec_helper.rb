# frozen_string_literal: true

# load all jars including with scope test
require 'jars/classpath'
Jars::Classpath.require(:test)

p $CLASSPATH

require 'rspec'

RSpec.configure do |config|
  config.order = 'random'
end
