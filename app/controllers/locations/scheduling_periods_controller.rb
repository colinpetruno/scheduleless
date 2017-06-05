module Locations
  class SchedulingPeriodsController < AuthenticatedController
    def create
      @location = current_company.locations.find(params[:location_id])
      @scheduling_period = @location.
        scheduling_periods.
        build(scheduling_period_params)

      authorize @scheduling_period

      if @scheduling_period.save
        @scheduling_period.generate_company_preview
      else
        render :new
      end
    end

    def index
      @location = current_company.locations.find(params[:location_id])

      @scheduling_periods = policy_scope(SchedulingPeriod)
    end

    def new
      @location = current_company.locations.find(params[:location_id])
      @scheduling_period = @location.scheduling_periods.build

      authorize @scheduling_period
    end

    private

    def scheduling_period_params
      params.
        require(:scheduling_period).
        permit(:start_date).
        merge(company_id: current_company.id)
    end
  end
end
