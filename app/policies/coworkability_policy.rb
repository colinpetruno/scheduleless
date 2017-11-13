class CoworkabilityPolicy < ApplicationPolicy
  def show?
    # todo gotta figure this out more
    UserPermissions.for(user).company_admin?
  end

  def edit?
    # todo gotta figure this out more
    UserPermissions.for(user).company_admin?
  end
end
