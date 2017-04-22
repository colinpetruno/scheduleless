module Scheduler
  class SchedulePreviewsController < AuthenticatedController

    def show
      authorize :schedule_preview, :show?
      @schedule = Scheduler::Schedule.for(current_company)
      @locations = policy_scope(Location)
    end

    def create
      authorize :schedule_preview, :create?
      location = current_company.locations.find(params[:location_id])
      @schedule = ::Schedule.new(company: current_company, location: location)
    end

    private

    def employees
      current_company.users
    end
  end
end