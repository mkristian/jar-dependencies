# walkthrough #

    * gem update ruby-maven
	* rmvn install
	* cd simple
	* rmvn install
	* cd ../inherited
	* rake build
	* jruby -Ilib -e 'require "inherited"'

basically jar-dependencies.gem is used to take care of loading jars which come in through the jar dependencies of the simple gem.

jar-dependencies can be told not to do anything in case the jars are already in classloader or classpath.

```JRUBY_SKIP_JARS=true jruby -Ilib -e 'require "inherited"'```

now you can look at the dependency tree of that gem:

```rmvn dependency:tree```

this means any maven based build system can handle those jar dependencies by setting either the environment variable **JRUBY_SKIP_JARS** or java system property **jruby.skip.jars** to true. in that case the gem would not need or use their verndored jars (beside their own extension jar if present).

any java project using ScriptingContainer can manage their jar as well the jars from gem (from those gems which do declare those jar dependencies in the gemspec !!).

the jar-dependencies gem is very basic and could be part of jruby itself as default gem or just use it as runtime dependency.

currently the simple/Mavenfile is a bit verbose to use the SNAPSHOT gem-maven-plugin.

# future #

the missing piece is to install the jars on gem install, via the extension API of rubygems. with that the whole thing would feel sound and round ;)

# motivation #

just today I tumbled across [https://github.com/arrigonialberto86/ruby-band](https://github.com/arrigonialberto86/ruby-band) which usees jbundler to manage their jar dependencies which happens on the first 'require "ruby-band"'. their is no easy or formal way to find out which jars are added to jruby-classloader.

another issue was brought to my notice yesterday [https://github.com/hqmq/derelicte/issues/1](https://github.com/hqmq/derelicte/issues/1)

or the question of how to manage jruby projects with maven [http://ruby.11.x6.nabble.com/Maven-dependency-management-td4996934.html](http://ruby.11.x6.nabble.com/Maven-dependency-management-td4996934.html)

or a few days ago an issue for the rake-compile [https://github.com/luislavena/rake-compiler/issues/87](https://github.com/luislavena/rake-compiler/issues/87)

with jruby-9000 coming it is the right time to get the jar dependencies right - the current situation is like the time before bundler for gems.
