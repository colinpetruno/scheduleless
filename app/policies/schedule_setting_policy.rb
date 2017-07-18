class ScheduleSettingPolicy < ApplicationPolicy
  def edit?
    UserPermissions.for(user).company_admin?
  end

  def update?
    UserPermissions.for(user).company_admin?
  end
end
