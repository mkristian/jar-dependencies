# jar-dependencies #

manage jar dependencies for gems and keep track which jar was already loaded using maven artifact coordinates. it warns on version conflicts and loads only ONE jar assuming the first one is compatible to the second one otherwise your project needs to lock down the right version.

# create a gem with jar dependencies #

see add you jar dependency declaration in gemspec via the **requirements**, see [sample.gemspec](sample.gemspec). add the **Rakefile** as extension and using the **setup** tasks from [ruby-maven](http://rubygems.org/gem/ruby-maven) to install the jar dependencies on installation of the gem - see [sample.Rakefile](sample.Rakefile).

the gem itself also needs **jar-dependencies** as runtime-dependency since that is used to load the jar or let [jbundler](http://rubygems.org/gem/jbundler) or similar frameworks deal with the jar dependencies.

# motivation #

just today I tumbled across [https://github.com/arrigonialberto86/ruby-band](https://github.com/arrigonialberto86/ruby-band) which usees jbundler to manage their jar dependencies which happens on the first 'require "ruby-band"'. their is no easy or formal way to find out which jars are added to jruby-classloader.

another issue was brought to my notice yesterday [https://github.com/hqmq/derelicte/issues/1](https://github.com/hqmq/derelicte/issues/1)

or the question of how to manage jruby projects with maven [http://ruby.11.x6.nabble.com/Maven-dependency-management-td4996934.html](http://ruby.11.x6.nabble.com/Maven-dependency-management-td4996934.html)

or a few days ago an issue for the rake-compile [https://github.com/luislavena/rake-compiler/issues/87](https://github.com/luislavena/rake-compiler/issues/87)

with jruby-9000 coming it is the right time to get the jar dependencies right - the current situation is like the time before bundler for gems.

