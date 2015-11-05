assuming jruby is used via rbenv, rvm, etc

## setup

```
bundle install
```

which is important since it will create a file lib/gem-name_jars.rb
and installs the jar dependencies into a local cache (local maven repository)

## use it

```
rackup
```

## lock down version of jar dependencies

lock down may or may not be needed. in case you want to lock down your versions for the jars execute:

```
lock_jars
```

