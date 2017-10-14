gemspecs = File.join(Gem.dir, 'specifications', 'ruby-maven-*gemspec')
Dir[gemspecs].each do |f|
  begin
    File.delete(f)
  rescue
    nil
  end
end

version = ARGV[0]
gem 'jar-dependencies', version.sub(/-SNAPSHOT/, '')

Kernel.at_exit do
  if Dir[gemspecs].size != 2
    raise "did not find two ruby-maven gems installed #{Dir[gemspecs]}"
  end
end

# this is like: gem install --ignore-dependencies, ../gem/pkg/my-1.1.1.gem
ARGV.replace(['install', '--ignore-dependencies', File.expand_path('../../gem/pkg/my-1.1.1.gem', __FILE__)])
load File.join(JRuby.runtime.instance_config.jruby_home, 'bin/gem')
