class Onboarding::SchedulesController < AuthenticatedController
  layout "onboarding"

  def new
    authorize :schedule, :create?

    employees = User.where(company_id: current_company.id)
    @schedule = Schedule.new(company: current_company)
  end

  def create
    authorize :schedule, :create?

    employees = User.where(company_id: current_company.id)
    @schedules = MultipleLocationsSchedule.
      new(company: current_company)
      #Scheduler::Schedule.for(current_company, employees)
  end
end
