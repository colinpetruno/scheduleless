class SchedulingHourPolicy < ApplicationPolicy
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

  def update?
    user.company_admin?
  end
end
