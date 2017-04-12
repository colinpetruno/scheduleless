class PositionPolicy < ApplicationPolicy
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
