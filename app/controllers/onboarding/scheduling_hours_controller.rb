module Onboarding
  class SchedulingHoursController < BaseController
    layout "onboarding"

    def show
      @location = current_company.locations.find(params[:location_id])
      @scheduling_hours = policy_scope(SchedulingHour)

      authorize @location
    end

    def update
      @location = current_company.locations.find(params[:location_id])
      authorize @location

      if @location.update(location_params)
        Onboarding::Status.for(current_company).move_to_next_step!(4)
        redirect_to new_onboarding_position_path
      else
        render :show
      end
    end

    private

    def location_params
      params.
        require(:location).
        permit(scheduling_hours_attributes: [
          :closed,
          :id,
          :minute_open_end,
          :minute_open_start
        ])
    end
  end
end
