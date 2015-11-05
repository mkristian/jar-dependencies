assuming jruby is used via rbenv, rvm, etc

## setup

it needs to install/lockdown the gems and the jars in with two commands

### install/lockdown the gems

```
bundle install
```

which is important since it will create a file lib/gem-name_jars.rb
and installs the jar dependencies into a local cache (local maven repository)

### install/lockdown the jars

since there is Jarfile the jar dependencies from there only get installed with


```
lock_jars
```

## use it

```
rackup
```



