module Scheduler
  class SchedulePreviewsController < AuthenticatedController

    def show
      authorize :schedule_preview, :show?
      @schedule = Scheduler::Schedule.for(current_company)
    end

    def create
      authorize :schedule_preview, :create?
      @schedule = ::Schedule.new(company: current_company)
    end

    private

    def employees
      current_company.users
    end
  end
end