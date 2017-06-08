class SchedulingPeriodPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      location.
        scheduling_periods.
        where(status: [
          :scheduleless_approved,
          :company_approved,
          :published,
          :closed
        ])
    end
  end

  def create?
    (user.company_admin? || location_admin_for?(current_location))
  end

  def new?
    (user.company_admin? || location_admin_for?(current_location))
  end

  def show?
    (user.company_admin? || location_admin_for?(current_location))
  end
end
