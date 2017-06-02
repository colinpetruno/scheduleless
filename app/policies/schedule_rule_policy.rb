class ScheduleRulePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.
        where(ruleable_id: user.company_id, ruleable_type: "Company").
        includes(:position).
        order("positions.name")
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

  def update?
    user.company_admin?
  end
end
