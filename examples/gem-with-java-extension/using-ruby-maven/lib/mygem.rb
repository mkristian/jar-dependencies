require Dir[ File.dirname(__FILE__) + "/*jar" ].first

puts Java::App.hello('world')
