## setup

```
vendor_jars
```

which is important since it will create a file lib/gem-name_jars.rb
and installs the jar dependencies into a local cache (local maven repository)

## lock down version of jar dependencies

lock down is optional and only needed once you see a warning about a version conflict. if you use maven recommended way of picking a concrete version for a jar then the need for lock_down is almost vanishing as the likelyhood of gems using the jar with different version is very small.

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

## alternative

uses jar-dependency gem as runtime dependency in your gemspec and bundler can be an alternative way of setting up such gem: [with bundler](gem-with-jar-dependencies-and-bundler/README.md). also see the discussion on pros and cons and the end of that page.
