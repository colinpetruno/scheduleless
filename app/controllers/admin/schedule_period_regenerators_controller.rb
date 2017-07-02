module Admin
  class SchedulePeriodRegeneratorsController < AdminController
    def create
      @scheduling_period = SchedulingPeriod.find(params[:scheduling_period_id])

      SchedulePeriodRegenerator.for(@scheduling_period).regenerate

      redirect_to admin_scheduling_period_path(@scheduling_period)
    end
  end
end
