# jar-dependencies #

* [![Build Status](https://secure.travis-ci.org/mkristian/jar-dependencies.svg)](http://travis-ci.org/mkristian/jar-dependencies)
* [![Code Climate](https://codeclimate.com/github/mkristian/jar-dependencies.svg)](https://codeclimate.com/github/mkristian/jar-dependencies)

add gem dependencies for jar files to ruby gems.


## getting control back over your jar ##

jar dependencies are declared in the gemspec of the gem using the same notation
as <https://github.com/mkristian/jbundler>.

when using `require_jar` to load the jar into JRuby's classloader a version conflict
will be detected and only **ONE** jar gets loaded.
**jbundler** allows to select the version suitable for you application.

most maven-artifact do **NOT** use versions ranges but depend on a concrete version.
in such cases **jbundler** can always **overwrite** any such version.


## vendoring your jars before packing the jar ##

add following to your *Rakefile*:

    require 'jars/installer'
    task :install_jars do
      Jars::Installer.vendor_jars!
    end

which will install (download) the dependent jars into **JARS_HOME** and create a
file **lib/my_gem_jars.rb** which will be an enumeration of `require_jars`
statements to load all the jars.
the **vendor_jars** task will copy them into the **lib** directory of the gem.

the location where jars are cached is per default **$HOME/.m2/repository** the
same default as Maven uses to cache downloaded jar-artifacts.
it respects **$HOME/.m2/settings.xml** from Maven with mirror and other settings
or the environment variable **JARS_HOME**.

**IMPORTANT**: make sure that jar-dependencies is only a **development dependency**
of your gem. if it is a runtime dependency the require_jars file will be overwritten
during installation.


## reduce the download and reuse the jars from maven local repository ##

if you do not want to vendor jars into a gem then **jar-dependency** gem can vendor
them when you install the gem. in that case do not use
`Jars::JarInstaller.install_jars` from the above rake tasks.

**NOTE**:recent JRuby comes with **jar-dependencies** as default gem, for older
versions for the feature to work you need to gem install **jar-dependencies** first
and for bundler need to use the **bundle-with-jars** command instead.

**IMPORTANT**: make sure that jar-dependencies is a **runtime dependency** of your
gem so the require_jars file will be overwritten during installation with the
"correct" versions of the jars.


## for development you do not need to vendor the jars at all ##

just set an environment variable

    export JARS_VENDOR=false

this tells the jar_installer not vendor any jars but only create the file with the
`require_jar` statements. this `require_jars` method will find the jar inside the
maven local repository and loads it from there.


## some drawbacks ##

 * first you need to install the jar-dependency gem with its development dependencies installed (then ruby-maven gets installed as well)
 * bundler does not install the jar-dependencies (unless JRuby adds the gem as default gem)
 * you need ruby-maven doing the job of dependency resolution and downloading them. gems not part of <http://rubygems.org> will not work currently


## jar others then from maven-central ##

per default all jars need to come from maven-central (<search.maven.org>), in order
to use jars from any other repo you need to add it into your Maven *settings.xml*
and configure it in a way that works without an interactive prompt (username +
passwords needs to be part of the settings.xml file).

**NOTE:** gems depending on jars other then maven-central will **NOT** work when
they get published on rubygems.org since the user of those gems will not have the
right settings.xml to allow them to access the jar dependencies.


## examples ##

an [example with rspec and all](example/Readme.md) walks you through setup and
shows how development works and shows what happens during installation.

there are some more examples with the various [project setups for gems and application](examples/README.md).
this includes using proper Maven for the project or ruby-maven with rake or
the rake-compiler in conjuction with jar-dependencies.

# lock down versions #

whenever there are version ranges for jar dependencies then it is advisable to lock down the versions of dependecies. for the jar dependencies inside the gemspec declaration this can be done with:

    lock_jars

this is also working in **any** project which uses a gem with
jar-dependencies. it also uses a Jarfile if present. see the [sinatra
application from the examples](examples/sinatra-app/having-jarfile-and-gems-with-jar-dependencies/).

this means for project using bundler and jar-dependencies the setup is

     bundle install
     lock_jars

which will install both gems and jars for the project.

update a specific version is done with (use only the artifact_id)

    lock_jars --update slf4j-api

and look at the dependencies tree

    lock_jars --tree

as ```lock_jars``` uses ruby-maven to resolve the jar dependencies.
since jar-dependencies does not declare ruby-maven as runtime dependency
(you just not need ruby-maven during runtime only when you want to
setup the project it is needed) it is advicable to have it as
development dependency in you Gemfile.

# proxy and mirror setup

proxied and mirrors can be setup by the usual configuration of maven itself: [settings.xml](https://maven.apache.org/settings.html) - see the mirrors and proxy sections.

as jar-dependencies does only deal with jar and all jars need to come from maven central, it is only neccessary to mirror maven-central. an example of such a [settings-example.xml](setting.xml is here).

you also can add such a settings.xml to your project which jar-dependencies will use instad of the default maven locations. this allows to have a per project configuration and also removes the need to users of your ruby project to dive into maven in case your have company policy to use a local mirror for gem and jar artifacts.

jar-dependencies itself uses maven **only** for the jars and all gems are managed by rubygems or bundler or your favourit management tool. so any proxy/mirror settings which should affect gems need to be done in those tools.

# gradle, maven, etc

for dependency management frameworks like gradle (via
jruby-gradle-plugin) or maven (via jruby-maven-plugins
or jruby9-maven-plugins) or probably ivy or sbt can use the gem
artifacts from a maven repository like
[rubygems-proxy from torquebox](http://rubygems-proxy.torquebox.org/)
or
[rubygems.lasagna.io/proxy/maven/releases](http://rubygems.lasagna.io/proxy/maven/releases/).

each of these tools (including jar-dependencies) does the dependency
resolution slightly different and in rare cases can produce different
outcomes. but overall each tool can manage both jars and gems and
their transitive dependencies.

popular gems like jrjackson or nokogiri do not declare their jars in
the gemspec files and just load the bundle jars into jruby
classloader, can easily create problems as the jackson and
xalan/xerces libraries used by those gems are popular ones in the java world.

# trouble shooting #

since maven is used under the hood it is possible to get more insight
what maven is doing. show the regualr maven output:


    JARS_VERBOSE=true bundle install
    JARS_VERBOSE=true gem install some_gem

or with maven debug enabled

    JARS_DEBUG=true bundle install
    JARS_DEBUG=true gem install some_gem

the maven command line which gets printed needs maven-3.3.x and the
ruby DSL extension for maven:
[https://github.com/takari/polyglot-maven#configuration](polyglot-maven
configuration) where ```${maven.multiModuleProjectDirectory}``` is
your current directory.

# configuration #

<table border='1'>
<tr>
<td>ENV</td><td>java system property</td><td>default</td><td>description</td>
</tr>
<tr>
<td><tt>JARS_DEBUG</tt></td><td>jars.debug</td><td>false</td><td>if set to true it will produce lots of debug out (maven -X switch)</td>
</tr>
<tr>
<td><tt>JARS_VERBOSE</tt></td><td>jars.verbose</td><td>false</td><td>if set to true it will produce some extra output</td>
</tr>
<tr>
<td><tt>JARS_HOME</tt></td><td>jars.home</td><td>$HOME/.m2/repository</td><td>filesystem location where to store the jar files and some metadata</td>
</tr>
<tr>
<td><tt>JARS_MAVEN_SETTINGS</tt></td><td>jars.maven.settings</td><td>$HOME/.m2/settings.xml</td><td>setting.xml for maven to use</td>
</tr>
<tr>
<td><tt>JARS_VENDOR</tt></td><td>jars.vendor</td><td>true</td><td>set to true means that the jars will be stored in JARS_HOME only</td>
</tr>
<tr>
<td><tt>JARS_SKIP</tt></td><td>jars.skip</td><td>true</td><td>do **NOT** install jar dependencies at all</td>
</tr>
</table>

# motivation #

just today I tumbled across [https://github.com/arrigonialberto86/ruby-band](https://github.com/arrigonialberto86/ruby-band) which usees jbundler to manage their jar dependencies which happens on the first 'require "ruby-band"'. their is no easy or formal way to find out which jars are added to jruby-classloader.

another issue was brought to my notice yesterday [https://github.com/hqmq/derelicte/issues/1](https://github.com/hqmq/derelicte/issues/1)

or the question of how to manage jruby projects with maven [http://ruby.11.x6.nabble.com/Maven-dependency-management-td4996934.html](http://ruby.11.x6.nabble.com/Maven-dependency-management-td4996934.html)

or a few days ago an issue for the rake-compile [https://github.com/luislavena/rake-compiler/issues/87](https://github.com/luislavena/rake-compiler/issues/87)

with JRuby 9000 it is the right time to get jar dependencies "right" - the current situation is like the time before bundler for gems.

