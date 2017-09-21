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

          # if the shift is deleted
          #  if active shift is present
          #    delete it
          #    record delete notification
          #  if its a repeating shift and the repeatig shift is marked deleted
          #    delete repeating shift
          #    if active shift present
          #      record delete notificaiton for series
          #
          # if the shift is not deleted
          #   if an active shift is present
          #     update params
          #     figure out changes
          #     return potential notifications
          #   else
          #     create new shift
          #     return potential notifications
          #
          #
          #  mark edited as false
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
