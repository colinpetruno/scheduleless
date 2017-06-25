module Remote
  class SchedulingPeriodsController < AuthenticatedController
    def show
      @location = current_company.locations.find(params[:location_id])
      @scheduling_period = current_company.scheduling_periods.find(params[:id])

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

    def view
      if params[:schedule_preview_view].present?
        cookies[:schedule_preview_view] = params[:schedule_preview_view]
      end

      cookies[:schedule_preview_view] ||  "day"
    end
  end
end
