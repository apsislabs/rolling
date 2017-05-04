module Rolling
  module Resource
    extend ActiveSupport::Concern

    included do

      # TODO: Verify the implementation of the Resource

      # def make_[role]
      # def make_member
      Rolling.roles_for_resource(klass: self) do |resource, role|
        define_method( "make_#{role}".to_sym ) do |permitted|
          raise ArgumentError.new("Argument must be a #{permitted_class_name}") unless resource.applies_to?(permitted: permitted)
          args = { resource.key => self, resource.permitted.key => permitted, :role => role }
          self.class.send("make_#{resource.permitted.key}_role".to_sym, args)
        end
      end

      # def remove_[permitted]
      # def remove_user
      Rolling.resources_for_resource(klass: self) do |resource|
        define_method( "remove_#{resource.permitted.key}".to_sym ) { |permitted|
          raise ArgumentError.new("Argument must be a #{resource.permitted_class_name}") unless resource.applies_to?(permitted: permitted)
          args = { resource.key => self, resource.permitted.key => permitted}
          self.class.send("remove_#{resource.permitted.key}".to_sym, args)
        }
      end

      # def [roles]
      # def members
      Rolling.roles_for_resource(klass: self) do |resource, role|
        define_method( "#{role.to_s.pluralize}".to_sym ) do
          args = { resource.key => self, :roles => [role] }
          self.class.send("#{resource.permitted.plural_name}_for_roles".to_sym, args)
        end
      end

      # def [permitted]_can_[permission]?
      # def user_can_view?
      Rolling.permissions_for_resource(klass: self) do |resource, permission|
        define_method( "#{resource.permitted.key}_can_#{permission}?".to_sym ) { |permitted|
          raise ArgumentError.new("Argument must be a #{permitted_class_name}") unless resource.applies_to?(permitted: permitted)
          args = { resource.key => self, resource.permitted.key => permitted}
          current_role = self.class.send("role_for_#{resource.permitted.key}".to_sym, args)

          return false unless current_role.present?

          permissions = resource.permissions_for(role: current_role.to_sym)
          permissions.include?(permission)
        }
      end

      # scope that_[permitted]_can_[permission]
      # scope that_user_can_view
      Rolling.permissions_for_resource(klass: self) do |resource, permission|
        scope( "that_#{resource.permitted.key}_can_#{permission}".to_sym, ->(permitted) {
          roles = resource.roles_for(permission: permission)
          send( "where_#{resource.permitted.key}_has_role".to_sym, permitted, roles: roles)
        })
      end
    end
  end
end
