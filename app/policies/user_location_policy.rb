class UserLocationPolicy < ApplicationPolicy
  def create?
    UserPermissions.for(user).company_admin?
  end

  def destroy?
    UserPermissions.for(user).company_admin?
  end
end
