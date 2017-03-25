class SchedulesManagementsController < AuthenticatedController

  def show
    @schedule = Scheduler::Schedule.for(current_company)
  end

  def create
    schedule = Scheduler::Schedule.for(current_company)
    schedule.generate_schedule_layout

    if schedule.generate_schedule
      schedule.print

      @shifts = schedule.shifts
    end
  end

  private

  def employees
    current_company.users
  end

end