module Remote
  module Calendar
    class RepeatingShiftsController < AuthenticatedController
      def create
        @repeating_shift = RepeatingShift.new(repeat_shift_params)

        authorize @repeating_shift

        @repeating_shift.save
      end

      def new
        @repeating_shift = RepeatingShift.new(repeat_shift_params)

        authorize @repeating_shift
      end

      private

      def repeat_shift_params
        params.
          require(:repeating_shift).
          permit(:position_id, :start_date, :user_id).
          merge(location_id: params[:location_id])
      end
    end
  end
end
