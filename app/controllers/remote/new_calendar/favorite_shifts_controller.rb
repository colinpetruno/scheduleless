module Remote
  module NewCalendar
    class FavoriteShiftsController < AuthenticatedController
      def create
      end

      def new
        @location = current_company.locations.find(params[:location_id])
        @favorite_shift = FavoriteShift.new(location_id: @location.id)

        authorize @favorite_shift
      end
    end
  end
end
