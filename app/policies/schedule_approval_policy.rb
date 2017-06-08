class ScheduleApprovalPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.company_admin?
        all_waiting_approvals
      elsif user.location_admin?
        approvals_for_locations
      else
        []
      end
    end

    def all_waiting_approvals
      user.
        company.
        scheduling_periods.
        includes(:company, :location).
        where(status: :scheduleless_approved)
    end

    def approvals_for_locations
      user.
        company.
        scheduling_periods.
        includes(:company, :location).
        where(status: :scheduleless_approved,
              location_id: user.locations.pluck(:id))
    end
  end
end
