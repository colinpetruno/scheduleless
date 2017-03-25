module Scheduler
  class SchedulePreviewsController < AuthenticatedController

    def show
      @schedule = Scheduler::Schedule.for(current_company)
    end

    def create
      @schedule = ::Schedule.new(company: current_company)
    end

    private

    def employees
      current_company.users
    end
  end
end