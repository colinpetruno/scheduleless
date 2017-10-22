class LocationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if UserPermissions.for(user).company_admin?
        user.company.locations.order(:name, :line_1)
      else
        user.locations.order(:name, :line_1)
      end
    end
  end

  def create?
    UserPermissions.for(user).company_admin?
  end

  def edit?
    UserPermissions.for(user).manage?(record) && same_company?
  end

  def new?
    UserPermissions.for(user).company_admin?
  end

  def show?
    user.locations.include?(current_location) || UserPermissions.for(user).company_admin?
  end

  def update?
    UserPermissions.for(user).manage?(record) && same_company?
  end
end
