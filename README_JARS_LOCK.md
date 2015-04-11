# Jars.lock

## native maven format

Jars.lock is essentially the output from ```mvn dependency:list -DoutputAbsoluteArtifactFilename=true -DincludeTypes=jar -DoutputScope=true -DoutputFile=Jars.lock``` (here the first line gets ignore as well all the whitespace)

    The following files have been resolved:
        io.dropwizard.metrics:metrics-healthchecks:jar:3.1.0:compile:/usr/local/repository/io/dropwizard/metrics/metrics-healthchecks/3.1.0/metrics-healthchecks-3.1.0.jar
        joda-time:joda-time:jar:2.5:provided:/usr/local/repository/joda-time/joda-time/2.5/joda-time-2.5.jar
        com.github.jnr:jffi:jar:native:1.2.7:provided:/usr/local/repository/com/github/jnr/jffi/1.2.7/jffi-1.2.7-native.jar
        junit:junit:jar:4.1:test:/usr/local/repository/junit/junit/4.1/junit-4.1.jar
        jdk.tools:jdk.tools:1.7:system:${java.home}/../lib/tools.jar

## formal definition

of each line can have either of these formats

    {groupId}:{artifactId}:{version}:{scope}:
    {groupId}:{artifactId}:{classifier}:{version}:{scope}:
    {groupId}:{artifactId}:{version}:{scope}:{path}
    {groupId}:{artifactId}:{classifier}:{version}:{scope}:{path}
    {groupId}:{artifactId}:jar:{version}:{scope}:
    {groupId}:{artifactId}:jar:{classifier}:{version}:{scope}:
    {groupId}:{artifactId}:jar:{version}:{scope}:{path}
    {groupId}:{artifactId}:jar:{classifier}:{version}:{scope}:{path}

the path is optional and gets ignored unless it contains a system property of the form like ```${java.home}``` which will be replaced respectively. so only system properties which are portable makes sense - like **java.home** (the only use-case I am aware of).

the **:jar** part is also optional to allow native maven format from the intro.

## Jars.lock filename

default to **Jars.lock** but can be overwritten by environment **JARS_LOCK** or system property **jars.lock**

## maven plugin support

gem-maven-plugin has a **jars-lock** goal which can produce Jars.lock file. see help on this goal for more options.
