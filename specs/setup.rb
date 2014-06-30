# single spec setup
$LOAD_PATH.unshift File.join( File.dirname( File.expand_path( File.dirname( __FILE__ ) ) ),
                              'lib' )


ENV['JARS_HOME'] = nil

begin
  require 'minitest'
rescue LoadError
end
require 'minitest/autorun'
