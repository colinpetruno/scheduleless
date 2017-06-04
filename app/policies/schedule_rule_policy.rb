class ScheduleRulePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      ruleable_type = location.present? ? "Location" : "Company"
      ruleable_id = location.present? ? location.id : user.company_id

      scope.
        where(ruleable_id: ruleable_id, ruleable_type: ruleable_type).
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
