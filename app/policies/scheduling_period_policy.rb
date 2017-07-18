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
    UserPermissions.for(user).manage?(current_location)
  end

  def new?
    UserPermissions.for(user).manage?(current_location)
  end

  def show?
    UserPermissions.for(user).manage?(current_location)
  end
end
