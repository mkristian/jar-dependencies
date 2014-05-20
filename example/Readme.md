# walkthrough #

(assume all commands will be executed via jruby !)

    rake build
	
this will install the jar dependencies, compile the java files and build the jar of the gem, generates *_jars.rb file which requires all the dependent jars and build the gem.

now install the gem

	gem install -l pkg/example-2.gem

during installation the dependent jars get vendored (not the jar extension which is part of the gem itself).

if you look into the gem itself it just contains the following files:

    .
    ├── example.gemspec
    ├── lib
    │   ├── example.jar
    │   ├── example_jars.rb
    │   └── example.rb
    └── Rakefile

and the installed gem looks like this

    .
	├── example.gemspec
	├── lib
	│   ├── example.jar
	│   ├── example_jars.rb
	│   ├── example.rb
	│   └── org
	│       └── bouncycastle
	│           ├── bcpkix-jdk15on
	│           │   └── 1.49
	│           │       └── bcpkix-jdk15on-1.49.jar
	│           └── bcprov-jdk15on
	│               └── 1.49
	│                   └── bcprov-jdk15on-1.49.jar
	└── Rakefile

in order to use the jar dependencies for development you need to run

    rake jar

which builds the **lib/example.jar** as well the **lib/example_jars.rb**. the latter will add the jar dependencies to jruby's runtime when required.

during development the jars will be stored in **$HOME/.m2/repository** (the maven default location). and that is the place where the jars get loaded from. when you install the gem via bundler (use bundle-with-jars command) or rubygems then the jars will vendored inside the gem.

in case you do not want to vendor your jars during installation, then you can set the environment **export JRUBY\_JARS\_VENDOR=false**. then the installed gem looks exactly like during development.

in any case the execution of the example.rb file produces the same output. the local development

    $ ruby -I lib/ -r example -e 1

or via the installed gem

    $ ruby -r example -e 1

gives:

    BouncyCastle Security Provider v1.49

with the environmen **JARS\_HOME** you can control the location of the local maven repository or use the **$HOME/.m2/settings.xml** to setup a custom local repository (the maven way). if you vendor the jars on install then the local maven repository is just a cache for those jars, if you do not vendor the jars, **jar\_dependencies** will use the jars directly from the local repository.
