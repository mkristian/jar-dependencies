# frozen_string_literal: true

# this file is maven DSL and used by maven via jars/lock_down.rb

basedir(ENV_JAVA['jars.basedir'])

def eval_file(file)
  file = File.join(__dir__, file)
  eval(File.read(file), nil, file) # rubocop:disable Security/Eval
end

eval_file('attach_jars_pom.rb')

jfile = ENV_JAVA['jars.jarfile']
jarfile(jfile) if jfile

# need to fix the version of this plugin for gem:jars_lock goal
jruby_plugin :gem, ENV_JAVA['jruby.plugins.version']

# if you use bundler we collect all root jar dependencies
# from each gemspec file. otherwise we need to resolve
# the gemspec artifact in the maven way
unless ENV_JAVA['jars.bundler']
  begin
    gemspec
  rescue
    nil
  end
end

properties('project.build.sourceEncoding' => 'utf-8')

plugin :dependency, ENV_JAVA['dependency.plugin.version']

eval_file('output_jars_pom.rb')
