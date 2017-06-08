module Admin
  class SchedulingPeriodsController < AdminController
    def show
      @scheduling_period = SchedulingPeriod.find(params[:id])
      @presenter = SchedulingPeriodShowPresenter.new(@scheduling_period)
    end

    def update
    end
  end
end
