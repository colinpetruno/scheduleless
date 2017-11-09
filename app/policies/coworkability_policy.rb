class CoworkabilityPolicy < ApplicationPolicy
  def edit?
    # todo gotta figure this out more
    UserPermissions.for(user).company_admin?
  end
end
