class RepeatingShiftPolicy < ApplicationPolicy
  def create?
    UserPermissions.for(user).manage?(current_location)
  end

  def edit?
    UserPermissions.for(user).manage?(current_location)
  end

  def new?
    UserPermissions.for(user).manage?(current_location)
  end

  def update?
    UserPermissions.for(user).manage?(current_location)
  end
end
