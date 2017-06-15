class ShiftPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      ShiftFinder.for(user).future.find
    end
  end

  def edit?
    user.company_admin?
  end

  def new?
    user.company_admin?
  end

  def create?
    user.company_admin?
  end

  def destroy?
    user.company_admin?
  end

  def update?
    user.company_admin?
  end
end
