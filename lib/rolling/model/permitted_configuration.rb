module Rolling
  module Model
    class PermittedConfiguration
      attr_accessor :key
      attr_accessor :resources

      def class_name
        key.to_s.classify
      end

      def plural_name
        key.to_s.pluralize
      end

      def is_permitted_for?(klass:)
        key.to_s.classify == klass.name
      end

      def self.from_hash(key, h)
        p = PermittedConfiguration.new
        p.key = key

        if h[:resources]
          p.resources = h[:resources].map { |resource_name, resource_data|
            [resource_name, ResourceConfiguration.from_hash(p, resource_name, resource_data)]
          }.to_h
        else
          p.resources = []
        end

        p
      end
    end
  end
end
