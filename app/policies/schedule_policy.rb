class SchedulePolicy < ApplicationPolicy
  def create?
    user.company_admin?
  end
end
