require_relative 'spec_helper'

describe 'java class App from src/main/java/**' do

  it 'should load bouncy castle' do
    Java::App.bc_info == 'BouncyCastle Security Provider v1.49'
  end

end
