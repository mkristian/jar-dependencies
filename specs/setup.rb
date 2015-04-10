# single spec setup
$LOAD_PATH.unshift File.join( File.dirname( File.expand_path( __FILE__ ) ), '../lib' )

ENV['JARS_HOME'] = nil
require 'jar_dependencies'

p ENV['JARS_LOCAL_MAVEN_REPO' ] = Jars.home
Jars.reset

begin
  require 'minitest'
rescue LoadError
end
require 'minitest/autorun'
