## setup

```
bundle
```

which is important since it will create a file lib/gem-name_jars.rb
and installs the jar dependencies into a local cache (local maven repository)

## lock down version of jar dependencies

lock down is optional only needed when there is a version conflict actually happening. (see [gem with jar dependency]((gem-with-jar-dependencies-and-bundler/README.md#lock down version of jar dependencies))

in case you want or need to lock down your versions for the jars then execute:

```
lock_jars
```

## pack gem

```
gem build mygem.gemspec
```

## just run the code

make sure you use jruby (via rbenv, rvm, etc)
```
ruby test.rb
```


## pros and cons

in the past there was problems with debian openjdk8 package which did not install the ca-certs in the java keystore and could not talk to maven central. the blame went naturally to the jar-dependencies project.

all in all vendoring jars within the gem is the recommended way of doing things, as the eco-system of gems with such jars using jar-dependencies is not so huge to playout the pros and it is unlikely to run into extra trouble while installing the gem.

### pros

- no jars get vendored inside the gem
- gems and jars are more or less treated a like
- you share the jars via the local maven repo between projects and/or gems

### cons

- any problem with installing the jars during gem install is very hard to debug
- any restricted access to the rubygems respository server needs to acompanied by the access rights for maven-central
- proxy support for downloading jar might be buggy
