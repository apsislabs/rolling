module Rolling
  module Model
    class ResourceConfiguration

      attr_accessor :permitted
      attr_accessor :key
      attr_accessor :roles
      attr_accessor :permissions
      attr_accessor :matrix

      def permitted_class_name
        permitted.class_name
      end

      def is_resource_for?(klass:)
        key.to_s.classify == klass.name
      end

      def applies_to?(permitted:)
        permitted.class.name == permitted_class_name
      end

      def roles_for(permission:)
        matrix.select { |r, permissions| permissions.include?(permission.to_sym) }.keys
      end

      def permissions_for(role:)
        matrix[role.to_sym]
      end

      def self.from_hash(permitted, key, h)
        r = ResourceConfiguration.new
        r.key = key
        r.permitted = permitted
        r.roles = h[:roles].map { |s| s.to_sym }
        r.permissions = h[:permissions].map { |s| s.to_sym }
        r.matrix = h[:matrix].map{ |k,v|
          [k, v.map { |s| s.to_sym }]
        }.to_h

        r
      end
    end
  end
end
