module Rolling
  module Permitted
    extend ActiveSupport::Concern

    included do

      # TODO: Verify the implementation of the Resource

      # def make_[resource]_[role]
      # def make_team_member
      Rolling.roles_for_permitted(klass: self) do |resource, role|
        define_method( "make_#{resource.key}_#{role}".to_sym ) do |resource_obj|
          # raise ArgumentError.new("Argument must be a #{permitted_class_name}") unless resource.applies_to?(permitted: permitted)
          args = { resource.key => resource_obj, resource.permitted.key => self, :role => role }
          resource_obj.class.send("make_#{resource.permitted.key}_role".to_sym, args)
        end
      end

      # def remove_from_[resource]
      # def remove_from_team
      Rolling.resources_for_permitted(klass: self) do |resource, role|
        define_method( "remove_from_#{resource.key}".to_sym ) do |resource_obj|
          # raise ArgumentError.new("Argument must be a #{permitted_class_name}") unless resource.applies_to?(permitted: permitted)
          args = { resource.key => resource_obj, resource.permitted.key => self }
          resource_obj.class.send("remove_#{resource.permitted.key}".to_sym, args)
        end
      end

      # def can_[permission]_[resource]?
      # def can_view_team?
      Rolling.permissions_for_permitted(klass: self) do |resource, permission|
        define_method( "can_#{permission}_#{resource.key}?".to_sym ) { |resource_obj|
          # raise ArgumentError.new("Argument must be a #{permitted_class_name}") unless resource.applies_to?(permitted: permitted)
          args = { resource.key => resource_obj, resource.permitted.key => self }
          current_role = resource_obj.class.send("role_for_#{resource.permitted.key}".to_sym, args)

          return false unless current_role.present?

          permissions = resource.permissions_for(role: current_role.to_sym)
          permissions.include?(permission)
        }
      end
    end
  end
end
