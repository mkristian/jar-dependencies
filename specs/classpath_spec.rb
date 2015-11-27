require File.expand_path('setup', File.dirname(__FILE__))

require 'yaml'
require 'jars/classpath'

module Helper
  def self.prepare!( array )
    result = array.collect do |a|
      a.sub( /-native.jar$/, '.jar').
        sub( /-[^-]+$/, '.jar').
        sub( /[^\/]+\/([^\/]+)$/, '\1').
        sub( /^.*META-INF.jruby.home.lib.ruby.s....../, '').
        sub( /.*#{Jars.home}./, '' ).
        sub( /.*#{Jars.local_maven_repo}./, '' ).
        sub( /.*repository./, '' ) # make sure we trim this
    end.select { |a| a != 'org/yaml/snakeyaml/snakeyaml.jar' && a != 'org/jruby/dirgra/dirgra.jar' && a != 'org/jruby/yecht/yecht.jar' }
    # omit ruby-maven jars
    result.delete_if { |c| c =~ /ruby-maven/ }
    result.uniq.sort
  end

  def self.reduce( big, small )
    (prepare!(big) - prepare!(small)).uniq.sort.to_yaml
  end

  def self.prepare( array )
    prepare!( array ).to_yaml
  end
end

describe Jars::Classpath do

  let( :deps ) { File.join( pwd, 'deps.txt' ) }

  let( :pwd ) { File.dirname( File.expand_path( __FILE__ ) ) }

  let( :jars_lock ) { File.join( pwd, 'Jars.lock' ) }

  let( :jars_no_jline_lock ) { File.join( pwd, 'Jars_no_jline.lock' ) }

  let( :example_spec ) { File.join( pwd, '..', 'example', 'example.gemspec' ) }

  let( :example_expected ) { ["joda-time/joda-time/2.3/joda-time-2.3.jar", "com/martiansoftware/nailgun-server/0.9.1/nailgun-server-0.9.1.jar", "com/github/jnr/jffi/1.2.7/jffi-1.2.7-native.jar", "org/ow2/asm/asm-analysis/4.0/asm-analysis-4.0.jar", "org/jruby/joni/joni/2.1.2/joni-2.1.2.jar", "com/jcraft/jzlib/1.1.2/jzlib-1.1.2.jar", "com/github/jnr/jnr-enxio/0.4/jnr-enxio-0.4.jar", "com/github/jnr/jnr-netdb/1.1.2/jnr-netdb-1.1.2.jar", "org/ow2/asm/asm-commons/4.0/asm-commons-4.0.jar", "org/ow2/asm/asm-util/4.0/asm-util-4.0.jar", "com/headius/invokebinder/1.2/invokebinder-1.2.jar", "org/ow2/asm/asm-tree/4.0/asm-tree-4.0.jar", "org/jruby/jruby-core/1.7.15/jruby-core-1.7.15.jar", "org/jruby/extras/bytelist/1.0.11/bytelist-1.0.11.jar", "org/jruby/jcodings/jcodings/1.0.10/jcodings-1.0.10.jar", "com/github/jnr/jnr-x86asm/1.0.2/jnr-x86asm-1.0.2.jar", "com/github/jnr/jffi/1.2.7/jffi-1.2.7.jar", "org/yaml/snakeyaml/1.13/snakeyaml-1.13.jar", "com/github/jnr/jnr-posix/3.0.6/jnr-posix-3.0.6.jar", "com/github/jnr/jnr-constants/0.8.5/jnr-constants-0.8.5.jar", "com/headius/options/1.2/options-1.2.jar", "com/github/jnr/jnr-unixsocket/0.3/jnr-unixsocket-0.3.jar", "com/github/jnr/jnr-ffi/1.0.10/jnr-ffi-1.0.10.jar", "org/ow2/asm/asm/4.0/asm-4.0.jar"] }

  let( :expected_with_bc ) { example_expected + bouncycastle }

  let( :lock_expected ) { ["org/apache/maven/maven-repository-metadata/3.1.0/maven-repository-metadata-3.1.0.jar", "com/google/code/findbugs/jsr305/1.3.9/jsr305-1.3.9.jar", "org/apache/httpcomponents/httpclient/4.2.3/httpclient-4.2.3.jar", "org/sonatype/sisu/sisu-guice/3.1.0/sisu-guice-no_aop-3.1.0.jar", "${java.home}/../lib/tools.jar", "org/sonatype/plexus/plexus-cipher/1.4/plexus-cipher-1.4.jar"]
 }

  let( :lock_expected_runtime ) { ["org/apache/maven/maven-repository-metadata/3.1.0/maven-repository-metadata-3.1.0.jar", "org/sonatype/sisu/sisu-guice/3.1.0/sisu-guice-no_aop-3.1.0.jar", "${java.home}/../lib/tools.jar", "org/sonatype/plexus/plexus-cipher/1.4/plexus-cipher-1.4.jar"] }

  let( :lock_expected_test ) { ["org/apache/maven/maven-repository-metadata/3.1.0/maven-repository-metadata-3.1.0.jar", "com/google/code/findbugs/jsr305/1.3.9/jsr305-1.3.9.jar", "org/apache/httpcomponents/httpclient/4.2.3/httpclient-4.2.3.jar", "org/sonatype/sisu/sisu-guice/3.1.0/sisu-guice-no_aop-3.1.0.jar", "${java.home}/../lib/tools.jar", "org/slf4j/slf4j-api/1.6.2/slf4j-api-1.6.2.jar", "org/sonatype/plexus/plexus-cipher/1.4/plexus-cipher-1.4.jar"] }

  let( :bc_prov ) { [ "org/bouncycastle/bcprov-jdk15on/1.49/bcprov-jdk15on-1.49.jar" ] }

  let( :bc_pkix ) { [ "org/bouncycastle/bcpkix-jdk15on/1.49/bcpkix-jdk15on-1.49.jar" ] }

  let( :bouncycastle ) { bc_pkix + bc_prov }

  subject { Jars::Classpath.new( example_spec ) }

  after do
    ENV_JAVA[ 'jars.quiet' ] = nil
    Jars.reset
  end

  it 'resolves classpath from gemspec' do
    ENV_JAVA[ 'jars.quiet' ] = 'true'
    Dir.chdir( File.dirname( example_spec ) ) do
      Helper.prepare( subject.classpath ).must_equal Helper.prepare( bouncycastle )

      Helper.prepare( subject.classpath( :compile ) ).must_equal Helper.prepare( expected_with_bc )

      Helper.prepare( subject.classpath( :test ) ).must_equal Helper.prepare( expected_with_bc << 'junit/junit/4.1/junit-4.1.jar' )

      Helper.prepare( subject.classpath( :runtime ) ).must_equal Helper.prepare( bouncycastle )
    end
  end

  it 'resolves classpath_string from gemspec' do
    Dir.chdir( File.dirname( example_spec ) ) do
      Helper.prepare( subject.classpath_string.split( /#{File::PATH_SEPARATOR}/ ) ).must_equal Helper.prepare( bouncycastle )

      Helper.prepare( subject.classpath_string( :compile ).split( /#{File::PATH_SEPARATOR}/ ) ).must_equal Helper.prepare( expected_with_bc )

      Helper.prepare( subject.classpath_string( :test ).split( /#{File::PATH_SEPARATOR}/ ) ).must_equal Helper.prepare( expected_with_bc << "junit/junit/4.1/junit-4.1.jar" )

      Helper.prepare( subject.classpath_string( :runtime ).split( /#{File::PATH_SEPARATOR}/ ) ).must_equal Helper.prepare( bouncycastle )
    end
  end

  it 'requires classpath from gemspec' do
    # TODO see not to require compile scope for 9k

    skip( 'TODO just use some empty jars for this spec' )
    
    skip( 'jruby-9.0.0.x can not require jruby core jars' ) if JRUBY_VERSION =~ /9.0.0.0/

    old = $CLASSPATH.to_a

    # sometimes the $CLASSPATH can already have BC jars
    # and it is not possible to unload entries from $CLASSPATH
    if old.detect {|c| c =~ /bcprov-jdk15on/ }
      if old.detect {|c| c =~ /bcpkix-jdk15on/ }
        expected = []
      else
        expected = bc_pkix
      end
    elsif old.detect {|c| c =~ /bcpkix-jdk15on/ }
      expected = bc_prov
    else
      expected = bouncycastle
    end

    subject.require( :runtime )

    Helper.reduce( $CLASSPATH.to_a, old ).must_equal Helper.prepare( expected )

    expected = expected + example_expected
    subject.require( :compile )
    Helper.reduce( $CLASSPATH.to_a, old ).must_equal Helper.prepare( expected )

    expected << "junit/junit/4.1/junit-4.1.jar"
    subject.require( :test )
    Helper.reduce( $CLASSPATH.to_a, old ).must_equal Helper.prepare( expected )
  end

  it 'processes Jars.lock if exists' do
    subject.instance_variable_set(:@deps, jars_lock )

    Helper.prepare( subject.classpath ).must_equal Helper.prepare( lock_expected_runtime )
    Helper.prepare( subject.classpath( :compile ) ).must_equal Helper.prepare( lock_expected )

    Helper.prepare( subject.classpath( :test ) ).must_equal Helper.prepare( lock_expected_test )

    Helper.prepare( subject.classpath( :runtime ) ).must_equal Helper.prepare( lock_expected_runtime )
  end

  it 'processes Jars.lock and block loading of jars' do
    subject.instance_variable_set(:@deps, jars_no_jline_lock )

    subject.require

    require_jar 'example', 'example', '1'
    $CLASSPATH.detect { |c| c =~ /example/ }.must_be_nil
  end
end
