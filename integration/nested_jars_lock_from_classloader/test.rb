# frozen_string_literal: true

require 'jar-dependencies'
require 'minitest/autorun'

basedir = ENV_JAVA['jars.home'] = __dir__

describe Jars do
  it 'requires Jars.lock from required jars' do
    Jars.require_jars_lock

    $CLASSPATH.collect do |c|
      c.sub(%r{file:#{basedir}/}, '')
    end.must_equal ['org/example/nested/1.0/nested-1.0.jar', 'jline/jline/2.11/jline-2.11.jar']
  end
end
