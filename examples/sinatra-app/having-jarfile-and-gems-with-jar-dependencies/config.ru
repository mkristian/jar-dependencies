$LOAD_PATH.unshift(__dir__)

require 'bundler/setup'

require 'app/hellowarld'

map '/' do
  run Sinatra::Application
end
