class SchedulePreviewPolicy < ApplicationPolicy
  def create?
    user.company_admin?
  end

  def show?
    user.company_admin?
  end
end
