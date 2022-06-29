# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'foo'
  version = '0.0.1'
  mdata = version.match(/(\d+\.\d+\.\d+)/)
  s.version = mdata ? mdata[1] : version
  s.authors = ['foo']
  s.summary = 'foo'
  s.required_ruby_version = '>= 2.6'
  s.metadata['rubygems_mfa_required'] = 'true'
end
