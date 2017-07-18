class SchedulePolicy < ApplicationPolicy
  def create?
    UserPermissions.for(user).company_admin?
  end

  def new?
    UserPermissions.for(user).company_admin?
  end
end
