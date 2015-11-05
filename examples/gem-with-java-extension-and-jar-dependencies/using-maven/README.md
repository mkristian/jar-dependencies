# using maven-3.3.x to build jar and pack gem

the ruby DSL for maven is configured by .mvn/extensions.xml

## setup

```
bundle install
```

which is important since it will create a file **lib/<gem-name>_jars.rb**
and installs the jar dependencies into a local cache (local maven-repository)

## build compile and create jar

```
mvn prepare-package
```

## use it

```
jruby test.rb
```

## lock down version of jar dependencies

lock down may or may not be needed. in case you want to lock down your versions for the jars execute:

```
lock_jars
```

## pack gem

```
mvn package
```

## deploy gem to rubygems.prg

```
mvn push
```