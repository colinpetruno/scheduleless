module Locations
  class InProgressShiftsController < AuthenticatedController
    def edit
      @location = current_company.locations.find(params[:location_id])
      @in_progress_shift = InProgressShift.
        where(company_id: current_company.id).
        find(params[:id])

      authorize :in_progress_shift, :edit?
    end

    def update
      @location = current_company.locations.find(params[:location_id])
      @in_progress_shift = InProgressShift.
        where(company_id: current_company.id).
        find(params[:id])

      authorize :in_progress_shift, :update?

      if @in_progress_shift.update(in_progress_shift_params)
        redirect_to locations_location_scheduling_period_path(
          @location,
          @in_progress_shift.scheduling_period)
      else
        render :edit
      end
    end

    private

    def in_progress_shift_params
      params.
        require(:in_progress_shift).
        permit(:minute_end, :minute_start, :user_id)
    end
  end
end
