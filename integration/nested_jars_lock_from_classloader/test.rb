#-*- mode: ruby -*-

require 'jar-dependencies'
require 'minitest/autorun'

basedir = ENV_JAVA['jars.home'] = File.expand_path(File.dirname(__FILE__))

describe Jars do
  it 'requires Jars.lock from required jars' do
    Jars.require_jars_lock

    list = $CLASSPATH.collect do |c|
      c.sub /file:#{basedir}\//, ''
    end.must_equal ['org/example/nested/1.0/nested-1.0.jar', 'jline/jline/2.11/jline-2.11.jar']
  end
end

# vim: syntax=Ruby
