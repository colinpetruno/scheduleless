class SchedulePreviewPolicy < ApplicationPolicy
  def create?
    UserPermissions.for(user).company_admin?
  end

  def show?
    UserPermissions.for(user).company_admin?
  end
end
