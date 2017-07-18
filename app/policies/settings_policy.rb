class SettingsPolicy < ApplicationPolicy
  def show?
    UserPermissions.for(user).company_admin?
  end
end
