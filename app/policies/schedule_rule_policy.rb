class ScheduleRulePolicy < ApplicationPolicy
  def create?
    user.company_admin?
  end

  def index?
    user.company_admin?
  end
end
