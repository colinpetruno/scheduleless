class AvailableEmployeesPolicy < ApplicationPolicy
  def index?
    UserPermissions.for(user).company_admin?
  end
end
