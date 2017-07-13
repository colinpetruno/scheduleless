module Onboarding
  class SchedulingHoursController < AuthenticatedController
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
        redirect_to new_onboarding_position_path(@location)
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
