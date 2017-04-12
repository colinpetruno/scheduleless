class SettingsPolicy < ApplicationPolicy
  def show?
    user.company_admin?
  end
end
