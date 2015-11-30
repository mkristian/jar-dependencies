require_relative 'spec_helper'

describe 'java class App from src/main/java/**' do

  it 'should load bouncy castle' do
    expect( Java::App.bc_info ).to eq 'BouncyCastle Security Provider v1.49'
    expect( Java::App.jruby_version ).to eq JRUBY_VERSION
    logger = org.slf4j.LoggerFactory.get_logger('root')
    logger.info(Java::App.hello('world'))
  end

end
