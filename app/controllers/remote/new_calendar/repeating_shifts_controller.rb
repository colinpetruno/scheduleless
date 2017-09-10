module Remote
  module NewCalendar
    class RepeatingShiftsController < AuthenticatedController
      def create
      end

      def new
        @location = current_company.locations.find(params[:location_id])
        @repeating_shift = RepeatingShift.new(location_id: @location.id)

        authorize @repeating_shift
      end
    end
  end
end
