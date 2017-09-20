module Remote
  module Calendar
    class RepeatingShiftsController < AuthenticatedController
      def create
        @repeating_shift = RepeatingShift.new(repeating_shift_params)

        authorize @repeating_shift

        @repeating_shift.save
      end

      def edit
        @repeating_shift = RepeatingShift.find(params[:id])

        authorize @repeating_shift
      end

      def new
        @repeating_shift = RepeatingShift.new(repeating_shift_params)

        authorize @repeating_shift
      end

      def update
        @repeating_shift = RepeatingShift.find(params[:id])

        authorize @repeating_shift

        Shifts::RepeatingShiftsUpdater.
          for(@repeating_shift).
            update(repeating_shift_params)
      end

      private

      def repeating_shift_params
        params.
          require(:repeating_shift).
          permit(:in_progress_shift_id,
                 :minute_end,
                 :minute_start,
                 :position_id,
                 :repeat_frequency,
                 :start_date,
                 :user_id).
          merge(location_id: params[:location_id])
      end
    end
  end
end
