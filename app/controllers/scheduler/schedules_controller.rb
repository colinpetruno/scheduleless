module Scheduler
  class SchedulesController < AuthenticatedController
    def create
      authorize :schedule, :create?

      current_company.update(company_params)
      redirect_to default_calender_path_for(current_user)
    end

    private

    def company_params
      params.
        require(:schedule).
        permit(shifts_attributes: [:company_id,
                                   :user_location_id,
                                   :minute_start,
                                   :minute_end,
                                   :date])
    end
  end
end