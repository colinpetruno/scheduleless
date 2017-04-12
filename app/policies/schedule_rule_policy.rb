class ScheduleRulePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(company_id: user.company_id)
    end
  end

  def create?
    user.company_admin? && same_company?
  end

  def index?
    user.company_admin?
  end
end
