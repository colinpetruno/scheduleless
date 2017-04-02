class SchedulesManagementsController < AuthenticatedController

  def show
    @schedule = Scheduler::Schedule.for(current_company)
  end

  def create
    schedule = Scheduler::Schedule.for(current_company)

    if schedule.generate
      schedule.print

      @shifts = schedule.shifts
    end
  end

  private

  def employees
    current_company.users
  end

end