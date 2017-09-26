class WagePolicy < ApplicationPolicy
  def index?
    UserPermissions.for(user).manage?(current_location) &&
      Features.for(company).wages?
  end
end
