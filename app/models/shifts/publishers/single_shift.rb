module Shifts
  module Publishers
    class SingleShift
      def initialize(in_progress_shift:, notify: true)
        @in_progress_shift = in_progress_shift
        @notify = notify
      end

      def publish
        return true unless in_progress_shift.edited?

        ActiveRecord::Base.transaction do
          if active_shift.present?
            # TODO: something different needs to happen here
            active_shift.update(shift_params)
          else
            Shift.create(shift_params)
          end

          if notify?
            # TODO: QUEUE NOTIFICATIONS
          end
        end
      end

      private

      def active_shift
        Shift.find_by(location_id: in_progress_shift.location_id,
                      in_progress_shift_id: in_progress_shift.id)
      end

      def notify?
        notify
      end

      def shift_params
        in_progress_shift.
          slice(:minute_start,
                :minute_end,
                :date,
                :location_id,
                :user_id).
          merge(in_progress_shift_id: in_progress_shift.id)
      end

      attr_reader :in_progress_shift, :notify
    end
  end
end
