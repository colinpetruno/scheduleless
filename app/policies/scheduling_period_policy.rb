class SchedulingPeriodPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      location.scheduling_periods
    end
  end

  def create?
    (user.company_admin? || user.location_admin_for?(current_location))
  end

  def new?
    (user.company_admin? || user.location_admin_for?(current_location))
  end
end
