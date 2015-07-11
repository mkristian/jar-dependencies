module Jars

  class GemspecArtifacts

    class Exclusion
      attr_reader :group_id, :artifact_id

      def initialize(line)
        @group_id, @artifact_id = line.gsub(/['"]/, '').strip.split( ':' )
        @artifact_id.strip!
      end

      def to_s
        "#{@group_id}:#{@artifact_id}"
      end
    end
    
    class Exclusions < Array

      def to_s
        "[#{join(', ')}]"
      end

      def initialize( line )
        super()
        line.gsub(/'"|^\s*\[|\]\s*$/, '').split( /,\s*/ ).each do |exclusion|
          self.<< Exclusion.new( exclusion )
        end
        freeze
      end
    end

    class Artifact
 
      attr_reader :type, :group_id, :artifact_id, :classifier, :version, :scope, :exclusions

      ALLOWED_TYPES = ['jar', 'pom']
      
      def initialize( options, *args )
        @type, @group_id, @artifact_id, @classifier, @version, @exclusions = *args
        options.each do |k,v|
          instance_variable_set( "@#{k}", v )
        end
      end

      def self.new( line )
        line = line.strip
        index = line.index( /\s/ )
        if index.nil?
          return nil
        end
        type = line[0..index].strip
        unless ALLOWED_TYPES.member?( type )
          return nil
        end
        line = line[index..-1]
        line.gsub!(/['"]/, '')
        line.strip!

        options = {}
        line.sub!(/,\s*:exclusions\s*(:|=>)\s*(\[[a-zA-Z0-9_:,]+\])/) do
          options[ :exclusions ] = Exclusions.new( $2.strip )
          ''
        end
        line.sub!(/,\s*:([a-z]+)\s*(:|=>)\s*(:?[a-zA-Z0-9_]+)/) do
          options[ $1.to_sym ] = $3.sub(/^:/, '')
          ''
        end

        exclusions = nil
        line.sub!(/[,:]\s*\[(.+:.+,?\s*)+\]$/) do |a|
          exclusions = Exclusions.new( a[1..-1].strip )
          ''
        end

        line.strip!
        line.gsub!(/,\s*/, ':')

        if line.match(/[\[\(\)\]]/)
          index = line.index(/[\[\(].+$/)
          version = line[index..-1].sub(/:/, ', ')
          line = line[0..index - 1].strip.sub(/:$/, '')
        else
          index = line.index(/[:][^:]+$/)
          version = line[index + 1..-1]
          line = line[0..index - 1].strip
        end

        case line.count(':')
        when 2
          group_id, artifact_id, classifier = line.split(':')
        when 1
          group_id, artifact_id = line.split(':')
          classifier = nil
        else
          warn line
          return nil
        end
        super( options, type, group_id, artifact_id, classifier, version, exclusions )
      end

      def to_s
        args = [@group_id, @artifact_id]
        args << @classifier if @classifier
        args << @version
        args << @exclusions.to_s if @exclusions
        "#{@type} #{group_id}:#{args[1..-1].join(', ')}"
      end

      def to_gacv
        args = [@group_id, @artifact_id]
        args << @classifier if @classifier
        args << @version
        args.join(', ')
      end

      def key
        args = [@group_id, @artifact_id]
        args << @classifier if @classifier
        args.join(':')
      end
    end

    attr_reader :artifacts

    def initialize( spec )
      @artifacts = []
      spec.requirements.each do |req|
        req.split( /\n/ ).each do |line|
          if ( a = Artifact.new( line ) )
            @artifacts << a
          end
        end
      end
      @artifacts.freeze
    end

    def [](index)
      @artifacts[index]
    end
  end
end
