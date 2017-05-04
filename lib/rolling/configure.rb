module Rolling
  module Configure
    @@roles_file = "roles.yml"
    @@roles = {}

    def configure
      yield self if block_given?
    end

    def roles
      @@roles
    end

    def roles=(value)
      @@roles = value
    end

    def roles_for_resource(klass:)
      resources_for_resource(klass: klass) do |resource|
        resource.roles.each do |role|
          yield resource, role
        end
      end
    end

    def permissions_for_resource(klass:)
      resources_for_resource(klass: klass) do |resource|
        resource.permissions.each do |permission|
          yield resource, permission
        end
      end
    end

    def roles_for_permitted(klass:)
      resources_for_permitted(klass: klass) do |resource|
        resource.roles.each do |role|
          yield resource, role
        end
      end
    end

    def permissions_for_permitted(klass:)
      resources_for_permitted(klass: klass) do |resource|
        resource.permissions.each do |permission|
          yield resource, permission
        end
      end
    end

    def resources_for_permitted(klass:)
      roles.each do |permitted, permitted_configuration|
        if (permitted_configuration.is_permitted_for?(klass: klass))
          permitted_configuration.resources.each do |resource, resource_configuration|
            yield resource_configuration
          end
        end
      end
    end

    def resources_for_resource(klass:)
      roles.each do |permitted, permitted_configuration|
        permitted_configuration.resources.each do |resource, resource_configuration|
          if resource_configuration.is_resource_for?(klass: klass)
            yield resource_configuration
          end
        end
      end
    end

    def permitted_for(permitted_class:)
      roles.each do |permitted, permitted_configuration|
        if (permitted_configuration.is_permitted_for?(klass: permitted_class))
          yield permitted_configuration
        end
      end
    end

    def roles_file
      @@roles_file
    end

    def roles_file=(value)
      @@roles_file = value
    end
  end
end
