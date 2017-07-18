class PreferencePolicy < ApplicationPolicy
  def edit?
    # TODO Make sure this is locked down to a proper preference
    UserPermissions.for(user).company_admin?
  end

  def update?
    # TODO Make sure this is locked down to a proper preference
    UserPermissions.for(user).company_admin?
  end
end
