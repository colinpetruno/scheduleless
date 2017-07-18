class PositionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(company_id: user.company_id)
    end
  end

  def create?
    UserPermissions.for(user).company_admin?
  end

  def destroy?
    UserPermissions.for(user).company_admin?
  end

  def edit?
    UserPermissions.for(user).company_admin?
  end

  def index?
    UserPermissions.for(user).company_admin?
  end

  def new?
    UserPermissions.for(user).company_admin?
  end

  def update?
    UserPermissions.for(user).company_admin?
  end

  def permitted_attributes
    [:company_admin, :location_admin, :name, managee_ids: [] ]
  end
end
