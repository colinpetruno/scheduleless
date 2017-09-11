module Remote
  module NewCalendar
    class FavoriteShiftsController < AuthenticatedController
      def create
        @favorite_shift = FavoriteShift.new(favorite_shift_params)

        authorize @favorite_shift

        @favorite_shift.save
      end

      def new
        @favorite_shift = FavoriteShift.new(favorite_shift_params)

        authorize @favorite_shift
      end

      private

      def favorite_shift_params
        params.
          require(:favorite_shift).
          permit(:end_minute, :position_id, :start_minute).
          merge(location_id: params[:location_id])
      end
    end
  end
end
