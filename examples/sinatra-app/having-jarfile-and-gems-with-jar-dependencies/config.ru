$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))

require 'bundler/setup'

require 'app/hellowarld'

map '/' do
  run Sinatra::Application
end
