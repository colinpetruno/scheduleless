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
    UserPermissions.for(user).company_admin?
  end

  def destroy?
    UserPermissions.for(user).company_admin?
  end

  def edit?
    UserPermissions.for(user).company_admin?
  end

  def index?
    UserPermissions.for(user).company_admin?
  end

  def update?
    UserPermissions.for(user).company_admin?
  end
end
