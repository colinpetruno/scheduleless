module Remote
  class InProgressShiftsController < AuthenticatedController
    def new
      @location = current_company.locations.find(params[:location_id])
      @shift = @location.in_progress_shifts.build(date: params[:date])

      authorize @shift
    end
  end
end
