class Onboarding::SchedulesController < AuthenticatedController
  layout "onboarding"

  def new
    authorize :schedule, :create?

    employees = User.where(company_id: current_company.id)
    @schedule = Scheduler::Schedule.for(current_company, employees)
  end

  def create
    authorize :schedule, :create?

    employees = User.where(company_id: current_company.id)
    @schedule = Scheduler::Schedule.for(current_company, employees)

    if @schedule.generate
      @schedule.print
      redirect_to calendar_path
    end
  end
end
