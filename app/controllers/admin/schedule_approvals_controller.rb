module Admin
  class ScheduleApprovalsController < AdminController
    def index
      @scheduling_periods = SchedulingPeriod.
        where(status: :generated).
        includes(:company)
    end
  end
end
