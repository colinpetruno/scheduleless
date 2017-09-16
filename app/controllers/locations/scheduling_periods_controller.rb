module Locations
  class SchedulingPeriodsController < AuthenticatedController
    def create
      @location = current_company.locations.find(params[:location_id])

      @scheduling_period = SchedulingPeriodCreator.
        new(date: date,
            location: @location,
            populate: params[:populate]).
        create

      authorize @scheduling_period

      redirect_to location_calendar_path(@location, date: date)
    end

    # TODO: these actions may be able to get cleaned up when new
    # scheduling gets launched
    def index
      @location = current_company.locations.find(params[:location_id])

      @scheduling_periods = policy_scope(SchedulingPeriod)
    end

    private

    def date
      Date.parse(params[:date].to_s)
    rescue
      nil
    end
  end
end
