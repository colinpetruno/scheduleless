class EmployeePositionPolicy < ApplicationPolicy
  def destroy?
    UserPermissions.for(user).manage?(current_location)
  end
end
