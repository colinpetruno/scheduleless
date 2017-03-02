class Onboarding::SchedulesController < AuthenticatedController
  layout "onboarding"

  def new
    @location = Location.find(params[:location_id])
    @schedule = Schedule.for(@location)
  end

  def create
    @location = Location.find(params[:location_id])
    @schedule = Schedule.for(@location)

    if @schedule.generate

    end
  end
end
