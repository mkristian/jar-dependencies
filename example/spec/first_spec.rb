require_relative 'spec_helper'

require 'example/bc_info'

describe 'example using a class from the dependent jars' do

  it 'should load bouncy castle' do
    Example.bc_info.should == 'BouncyCastle Security Provider v1.49'
  end

end
