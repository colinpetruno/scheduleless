module Remote
  module NewCalendar
    class InProgressShiftsController < AuthenticatedController
      def new
        @scheduling_period = current_company.
          scheduling_periods.
          find(params[:scheduling_period_id])
        @location = current_company.locations.find(@scheduling_period.location_id)
        @shift = @scheduling_period.in_progress_shifts.build(new_shift_params)

        authorize @shift
      end

      private

      def new_shift_params
        { date: params[:date], location_id: @location.id }
      end
    end
  end
end
