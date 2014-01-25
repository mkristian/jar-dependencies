# jar-dependencies #

manage jar dependencies for gems and keep track which jar was already loaded using maven artifact coordinates. it warns on version conflicts and loads only ONE jar assuming the first one is compatible to the second one otherwise your project needs to lock down the right version.

via environment variable or system properties the jar loading can be switched of completely, allowing the servlet container or jbundler or any other container to take care of the jar loading.

in case the jars are vendored using the following path convention

**{group\_id}/{artifact\_id}-{version}.jar**

it will be loaded in case the local maven repository does not have it (maybe the preference should be the other way around ?).

the gem is tiny on purpose since the all gems with jar dependencies should use and funny double loaded jars can be avoided in future. also java project using the jruby ScriptingContainer can manage their jar dependencies including those coming from the gem files.

# create a gem with jar dependencies #

see add you jar dependency declaration in gemspec via the **requirements**, see [example.gemspec](example/example.gemspec). create an extension **ext/extconf.rb** and use the **setup** from [ruby-maven](http://rubygems.org/gem/ruby-maven) to install the jar dependencies on installation of the gem - see [ext/extconf.rb](example/ext/extconf.rb). this setup will create **{gem.name}\_jars.rb** inside the lib directory (**require_path** of the gemspec) of your gem .

note: you need ruby-maven-3.1.1.0.3.dev or newer for the GemSetup class

your gem just need require this **{gem.name}_jars.rb** in your code whenever you want to load these jars (see [lib/example.rb](example/lib/example.rb)).

the gem itself also needs the **jar-dependencies** gem as runtime-dependency since that is used to load the jar or let [jbundler](http://rubygems.org/gem/jbundler) or similar frameworks deal with the jar dependencies.

# motivation #

just today I tumbled across [https://github.com/arrigonialberto86/ruby-band](https://github.com/arrigonialberto86/ruby-band) which usees jbundler to manage their jar dependencies which happens on the first 'require "ruby-band"'. their is no easy or formal way to find out which jars are added to jruby-classloader.

another issue was brought to my notice yesterday [https://github.com/hqmq/derelicte/issues/1](https://github.com/hqmq/derelicte/issues/1)

or the question of how to manage jruby projects with maven [http://ruby.11.x6.nabble.com/Maven-dependency-management-td4996934.html](http://ruby.11.x6.nabble.com/Maven-dependency-management-td4996934.html)

or a few days ago an issue for the rake-compile [https://github.com/luislavena/rake-compiler/issues/87](https://github.com/luislavena/rake-compiler/issues/87)

with jruby-9000 coming it is the right time to get the jar dependencies right - the current situation is like the time before bundler for gems.

