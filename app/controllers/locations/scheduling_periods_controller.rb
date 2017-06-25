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

        redirect_to(
          locations_location_scheduling_period_path(
            @location,
            @scheduling_period
          )
        )
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

    def show
      @location = current_company.locations.find(params[:location_id])
      @scheduling_period = @location.scheduling_periods.find(params[:id])

      authorize @scheduling_period

      @presenter = SchedulingPeriodShowPresenter.
        new(@scheduling_period, date, view)
    end

    private

    def date
      params[:date].to_i if params[:date].present?
    rescue
      nil
    end

    def scheduling_period_params
      params.
        require(:scheduling_period).
        permit(:start_date).
        merge(company_id: current_company.id)
    end

    def view
      if params[:schedule_preview_view].present?
        cookies[:schedule_preview_view] = params[:schedule_preview_view]
      end

      cookies[:schedule_preview_view] ||  "day"
    end


  end
end
