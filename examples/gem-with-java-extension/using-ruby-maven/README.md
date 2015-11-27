# using rake and ruby-maven gem

## setup

```
bundle install
```

which is important since it will create a file lib/gem-name_jars.rb
and installs the jar dependencies into a local cache (local maven repository)

## build compile and create jar

```
rake compile
```

## pack gem

```
rake package
```

## just run the code

make sure you use jruby (via rbenv, rvm, etc)
```
jruby test.rb
```