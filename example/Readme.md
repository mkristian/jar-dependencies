# walkthrough #

(assume all commands will be executed via jruby !)

    bundle install
    lock_jars
	rake
	rake package

* bundler will lock down the gem dependencies and generates the *_jars.rb file
* lock\_jars does create JArs.lock file the version lock down of the
jar dependencies. see ```lock_jars --help``` for more options.
* the default rake task compile the java files and runs the specs after it
* the rake task compiles the java files and builds the jar of the gem
  and packs everything into a gem

now install the gem and look at the installed content

    gem install -l pkg/example-2-java.gem
    gem content example

during installation the dependent jars get vendored (not the jar
extension which is already part of the packed gem itself).

to run the spec do (after ```bundle install```)

    bundle exec rake

or

	bundle exec rake compile
    bundle exec rspec spec/*spec.rb


if you look into the gem itself it just contains the following files:

    .
    ├── example.gemspec
    ├── lib│
	|   ├── example
    │   │   └── bc_info.rb
    │   ├── example.jar
    │   ├── example_jars.rb
    │   └── example.rb
    └── Rakefile

and the installed gem looks like this

    .
	├── Gemfile
	├── Rakefile
	├── example.gemspec
	└── lib
		├── example
		│   └── bc_info.rb
		├── example.jar
		├── example.rb
		├── example_jars.rb
		└── org
			├── bouncycastle
			|   ├── bcpkix-jdk15on
			│   │   └── 1.49
			│   │       └── bcpkix-jdk15on-1.49.jar
			│   └── bcprov-jdk15on
			│       └── 1.49
			│           └── bcprov-jdk15on-1.49.jar
			└── slf4j
				└── slf4j-api
					└── 1.7.7
						└── slf4j-api-1.7.7.jar

in order to use the jar dependencies for development you need to run

    rake compile

which builds the **lib/example.jar** and

    bundle install

generates the **lib/example_jars.rb**. this file adds the jar dependencies to jruby's runtime when required.

during development the jars will be stored in **$HOME/.m2/repository**
(the maven default location). this local-maven-repository can be
configured with the settings.xml from the project or at
**$HOME/.m2/settings.xml**. from the local-maven-repository the jars
get loaded. whenever you install the gem via bundler or rubygems then the
jars will vendored inside the gem.

in case you do not want to vendor your jars during installation, then you can set the environment **export JRUBY\_JARS\_VENDOR=false**. then the installed gem looks exactly like during development.

in any case the execution of the example.rb file produces the same output. the local development

    $ jruby -Ilib -r example/bc_info -e 'puts Example.bc_info'

or via the installed gem

    $ jruby -r example/bc_info -e 'puts Example.bc_info'

gives:

    BouncyCastle Security Provider v1.49

for mirror or proxy settings either use the settings.xml from the
project or from $HOME/.m2/settings.xml and see maven documentions on
more details on this and the settings.xml.example of here.
