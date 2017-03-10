class Onboarding::SchedulesController < AuthenticatedController
  layout "onboarding"

  def new
    @schedule = Schedule.for(current_company)
  end

  def create
    @schedule = Schedule.for(current_company)

    if @schedule.generate
      redirect_to calendar_path
    end
  end
end
