class PositionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(company_id: user.company_id)
    end
  end

  def create?
    user.company_admin?
  end

  def destroy?
    user.company_admin?
  end

  def edit?
    user.company_admin?
  end

  def index?
    user.company_admin?
  end

  def new?
    user.company_admin?
  end

  def update?
    user.company_admin?
  end

  def permitted_attributes
    [:company_admin, :location_admin, :name]
  end
end
