class PositionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(company_id: user.company_id)
    end
  end

  def create?
    user.company_admin?
  end

  def index?
    user.company_admin?
  end

  def new?
    user.company_admin?
  end
end
