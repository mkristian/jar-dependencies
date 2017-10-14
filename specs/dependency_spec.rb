require File.expand_path('setup', File.dirname(__FILE__))

require 'jar_installer'

describe Jars::JarInstaller::Dependency do
  it 'should parse dependency line only if it is jar or pom' do
    Jars::JarInstaller::Dependency.new('something').must_be_nil
    Jars::JarInstaller::Dependency.new('   org.apache.maven:maven-repository-metadata:jar:3.1.0:compile:/usr/local/repository/org/apache/maven/maven-repository-metadata/3.1.0/maven-repository-metadata-3.1.0.jar').wont_be_nil
    Jars::JarInstaller::Dependency.new('   org.apache.maven:maven-repository-metadata:pom:3.1.0:compile:/usr/local/repository/org/apache/maven/maven-repository-metadata/3.1.0/maven-repository-metadata-3.1.0.jar').wont_be_nil
  end

  it 'should parse dependency line test scope' do
    dep = Jars::JarInstaller::Dependency.new('   org.apache.maven:maven-repository-metadata:jar:3.1.0:test:/usr/local/repository/org/apache/maven/maven-repository-metadata/3.1.0/maven-repository-metadata-3.1.0.jar')
    dep.type.must_equal :jar
    dep.scope.must_equal :test
    dep.gav.must_equal 'org.apache.maven:maven-repository-metadata:3.1.0'
    dep.coord.must_equal 'org.apache.maven:maven-repository-metadata:jar:3.1.0'
    dep.path.must_equal 'org/apache/maven/maven-repository-metadata/3.1.0/maven-repository-metadata-3.1.0.jar'
    dep.file.must_equal '/usr/local/repository/org/apache/maven/maven-repository-metadata/3.1.0/maven-repository-metadata-3.1.0.jar'
  end

  it 'should parse dependency line provided scope' do
    dep = Jars::JarInstaller::Dependency.new('   org.apache.maven:maven-repository-metadata:jar:3.1.0:provided:/usr/local/repository/org/apache/maven/maven-repository-metadata/3.1.0/maven-repository-metadata-3.1.0.jar')
    dep.type.must_equal :jar
    dep.scope.must_equal :provided
    dep.gav.must_equal 'org.apache.maven:maven-repository-metadata:3.1.0'
    dep.coord.must_equal 'org.apache.maven:maven-repository-metadata:jar:3.1.0'
    dep.path.must_equal 'org/apache/maven/maven-repository-metadata/3.1.0/maven-repository-metadata-3.1.0.jar'
    dep.file.must_equal '/usr/local/repository/org/apache/maven/maven-repository-metadata/3.1.0/maven-repository-metadata-3.1.0.jar'
  end

  it 'should parse dependency line runtim scope' do
    dep = Jars::JarInstaller::Dependency.new('   org.apache.maven:maven-repository-metadata:jar:3.1.0:compile:/usr/local/repository/org/apache/maven/maven-repository-metadata/3.1.0/maven-repository-metadata-3.1.0.jar')
    dep.type.must_equal :jar
    dep.scope.must_equal :runtime
    dep.gav.must_equal 'org.apache.maven:maven-repository-metadata:3.1.0'
    dep.coord.must_equal 'org.apache.maven:maven-repository-metadata:jar:3.1.0'
    dep.path.must_equal 'org/apache/maven/maven-repository-metadata/3.1.0/maven-repository-metadata-3.1.0.jar'
    dep.file.must_equal '/usr/local/repository/org/apache/maven/maven-repository-metadata/3.1.0/maven-repository-metadata-3.1.0.jar'

    dep = Jars::JarInstaller::Dependency.new('   org.apache.maven:maven-repository-metadata:jar:3.1.0:runtime:/usr/local/repository/org/apache/maven/maven-repository-metadata/3.1.0/maven-repository-metadata-3.1.0.jar')
    dep.type.must_equal :jar
    dep.scope.must_equal :runtime
    dep.gav.must_equal 'org.apache.maven:maven-repository-metadata:3.1.0'
    dep.coord.must_equal 'org.apache.maven:maven-repository-metadata:jar:3.1.0'
    dep.path.must_equal 'org/apache/maven/maven-repository-metadata/3.1.0/maven-repository-metadata-3.1.0.jar'
    dep.file.must_equal '/usr/local/repository/org/apache/maven/maven-repository-metadata/3.1.0/maven-repository-metadata-3.1.0.jar'
  end

  it 'should parse pom dependency' do
    dep = Jars::JarInstaller::Dependency.new('   org.apache.maven:maven-repository-metadata:pom:3.1.0:compile:/usr/local/repository/org/apache/maven/maven-repository-metadata/3.1.0/maven-repository-metadata-3.1.0.pom')
    dep.type.must_equal :pom
    dep.scope.must_equal :runtime
    dep.gav.must_equal 'org.apache.maven:maven-repository-metadata:3.1.0'
    dep.coord.must_equal 'org.apache.maven:maven-repository-metadata:pom:3.1.0'
    dep.path.must_equal 'org/apache/maven/maven-repository-metadata/3.1.0/maven-repository-metadata-3.1.0.pom'
    dep.file.must_equal '/usr/local/repository/org/apache/maven/maven-repository-metadata/3.1.0/maven-repository-metadata-3.1.0.pom'
  end

  it 'should parse dependency where artifact_id has dots' do
    dep = Jars::JarInstaller::Dependency.new('   org.eclipse.sisu:org.eclipse.sisu.plexus:jar:0.0.0.M2a:compile:/usr/local/repository/org/eclipse/sisu/org.eclipse.sisu.plexus/0.0.0.M2a/org.eclipse.sisu.plexus-0.0.0.M2a.jar')
    dep.type.must_equal :jar
    dep.scope.must_equal :runtime
    dep.gav.must_equal 'org.eclipse.sisu:org.eclipse.sisu.plexus:0.0.0.M2a'
    dep.coord.must_equal 'org.eclipse.sisu:org.eclipse.sisu.plexus:jar:0.0.0.M2a'
    dep.path.must_equal 'org/eclipse/sisu/org.eclipse.sisu.plexus/0.0.0.M2a/org.eclipse.sisu.plexus-0.0.0.M2a.jar'
    dep.file.must_equal '/usr/local/repository/org/eclipse/sisu/org.eclipse.sisu.plexus/0.0.0.M2a/org.eclipse.sisu.plexus-0.0.0.M2a.jar'
  end

  it 'should parse dependency with classifier' do
    dep = Jars::JarInstaller::Dependency.new('   org.sonatype.sisu:sisu-guice:jar:no_aop:3.1.0:compile:/usr/local/repository/org/sonatype/sisu/sisu-guice/3.1.0/sisu-guice-3.1.0-no_aop.jar')
    dep.type.must_equal :jar
    dep.scope.must_equal :runtime
    dep.gav.must_equal 'org.sonatype.sisu:sisu-guice:no_aop:3.1.0'
    dep.coord.must_equal 'org.sonatype.sisu:sisu-guice:jar:no_aop:3.1.0'
    dep.path.must_equal 'org/sonatype/sisu/sisu-guice/3.1.0/sisu-guice-3.1.0-no_aop.jar'
    dep.file.must_equal '/usr/local/repository/org/sonatype/sisu/sisu-guice/3.1.0/sisu-guice-3.1.0-no_aop.jar'
  end

  it 'should parse dependency on windows' do
    dep = Jars::JarInstaller::Dependency.new('   org.sonatype.sisu:sisu-guice:jar:no_aop:3.1.0:compile:C:\\Users\\Local\\repository\\org\\sonatype\\sisu\\sisu-guice\\3.1.0\\sisu-guice-3.1.0-no_aop.jar')
    dep.type.must_equal :jar
    dep.scope.must_equal :runtime
    dep.gav.must_equal 'org.sonatype.sisu:sisu-guice:no_aop:3.1.0'
    dep.coord.must_equal 'org.sonatype.sisu:sisu-guice:jar:no_aop:3.1.0'
    dep.path.must_equal 'org/sonatype/sisu/sisu-guice/3.1.0/sisu-guice-3.1.0-no_aop.jar'
    dep.file.must_equal 'C:\\Users\\Local\\repository\\org\\sonatype\\sisu\\sisu-guice\\3.1.0\\sisu-guice-3.1.0-no_aop.jar'
  end
end
