## setup

```
vendor_jars
```

which is important since it will create a file lib/gem-name_jars.rb
and installs the jar dependencies into a local cache (local maven repository)

## lock down version of jar dependencies

lock down is optional. in case you want or need to lock down your versions for the jars then execute:

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
