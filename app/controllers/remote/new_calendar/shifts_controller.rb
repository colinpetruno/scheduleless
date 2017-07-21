module Remote
  module NewCalendar
    class ShiftsController < AuthenticatedController
      def new
        @location = current_company.locations.find(params[:location_id])
        @shift = @location.shifts.build(new_shift_params)

        authorize @shift
      end

      private

      def new_shift_params
        { date: params[:date] }
      end
    end
  end
end
