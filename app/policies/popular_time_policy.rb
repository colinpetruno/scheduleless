class PopularTimePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(popular_id: user.company_id)
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

  def new?
    UserPermissions.for(user).company_admin?
  end

  def update?
    UserPermissions.for(user).company_admin?
  end
end
