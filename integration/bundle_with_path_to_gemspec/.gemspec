Gem::Specification.new do |s|
  s.name = "foo"
  version = "0.0.1"
  mdata = version.match(/(\d+\.\d+\.\d+)/)
  s.version = mdata ? mdata[1] : version
  s.authors = ["foo"]
  s.summary = "foo"
end
