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

## use it

```
jruby test.rb
```

## pack gem

```
rake package
```
