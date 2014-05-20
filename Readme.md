# jar-dependencies #

add gem dependencies for jar files to ruby gems.

## features ##

    * vendors jar dependencies during installion of the gem
	* jar dependencies are declared in the gemspec of the gem
	* jar declaration uses the same notation as jbundler
	* transitive jar dependencies will be resolved as well using (ruby-)maven
	* when there are two gems with different versions of the same jar dependency an warning will be given and the first version wins, i.e. **only one** version of the a library inside the jruby-classloader
	* it hooks into gem, i.e. once the jar-dependency gem is installed the feature can be used by any gem
	* offer 'bundle-with-jars' command which hooks the jar_installer into rubytems before delegating all arguments to bundler
	* it integrates with an existing maven local repository and obeys the maven setup in ~/.m2/settings.xml, like mirrors, proxieds, etc

## some drawbacks ##

    * first you need to install the jar-dependency gem with its development dependencies installed (then ruby-maven gets installed as well)
	* bundler does not install the jar-dependencies
	* gems need an extra dependency on jar-dependencies during runtime and for development and installation you need ruby-maven installed as well (which you get via the development dependencies)

## just look at the example ##

the [readme.md](example/Readme.md) walks you through an example and shows how development works and shows what happens during installation.

# configuration #

<table border='1'>
<tr>
<td>ENV</td><td>java system property</td><td>default</td><td>description</td>
</tr>
<tr>
<td>`JARS_DEBUG`</td><td>jars.debug</td><td>false</td><td>if set to true it will produce lots of debug out (maven -X switch)</td>
</tr>
<tr>
<td>`JARS_VERBOSE`</td><td>jars.verbose</td><td>false</td><td>if set to true it will produce some extra output</td>
</tr>
<tr>
<td>`JARS_HOME`</td><td>jars.home</td><td>$HOME/.m2/repository</td><td>filesystem location where to store the jar files and some metadata</td>
</tr>
<tr>
<td>`JARS_MAVEN_SETTINGS`</td><td>jars.maven.settings</td><td>$HOME/.m2/settings.xml</td><td>setting.xml for maven to use</td>
</tr>
<tr>
<td>`JARS_VENDOR`</td><td>jars.vendor</td><td>true</td><td>set to true means that the jars will be stored in JARS_HOME only</td>
</tr>
</table>

# motivation #

just today I tumbled across [https://github.com/arrigonialberto86/ruby-band](https://github.com/arrigonialberto86/ruby-band) which usees jbundler to manage their jar dependencies which happens on the first 'require "ruby-band"'. their is no easy or formal way to find out which jars are added to jruby-classloader.

another issue was brought to my notice yesterday [https://github.com/hqmq/derelicte/issues/1](https://github.com/hqmq/derelicte/issues/1)

or the question of how to manage jruby projects with maven [http://ruby.11.x6.nabble.com/Maven-dependency-management-td4996934.html](http://ruby.11.x6.nabble.com/Maven-dependency-management-td4996934.html)

or a few days ago an issue for the rake-compile [https://github.com/luislavena/rake-compiler/issues/87](https://github.com/luislavena/rake-compiler/issues/87)

with jruby-9000 coming it is the right time to get the jar dependencies right - the current situation is like the time before bundler for gems.

