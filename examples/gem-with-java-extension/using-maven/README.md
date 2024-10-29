# using maven-3.9.x to build jar and pack gem

the ruby DSL for maven is configured by .mvn/extensions.xml

## build compile and create jar

```
mvn prepare-package
```

## pack gem

```
mvn package
```

## deploy gem tio rubygems.prg

```
mvn push
```

## just run the code

make sure you use jruby (via rbenv, rvm, etc)
```
jruby test.rb
```