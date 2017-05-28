class PopularTimePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(popular_id: user.company_id)
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

  def new?
    user.company_admin?
  end

  def update?
    user.company_admin?
  end
end
