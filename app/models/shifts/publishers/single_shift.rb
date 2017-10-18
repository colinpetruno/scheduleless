module Shifts
  module Publishers
    class SingleShift
      def initialize(in_progress_shift:, notify: true, delete_series: true)
        @delete_series = delete_series
        @in_progress_shift = in_progress_shift
        @notify = notify
      end

      def publish
        return true unless in_progress_shift.edited?

        ActiveRecord::Base.transaction do
          if deleted?
            delete_in_progress_shifts
          else
            if published?
              update_existing_shift
            else
              create_new_shift
            end

            in_progress_shift.update(edited: false, published: true)
          end
        end
      end

      private

      def create_new_shift
        Utilities::ShiftCreator.create_from(in_progress_shift)

        if repeating?
          repeating_shift = in_progress_shift.repeating_shift
          repeating_shift.update(published: true)


          InProgressShift.
            where(repeating_shift_id: repeating_shift.id).
            update_all(edited: false, published: true)
        end

        if notify?
          Notifications::ScheduleUpdatedJob.
            perform_later(in_progress_shift.user_id,
                          Marshal.dump([:shift_added]))
        end
      end

      def update_existing_shift
        Utilities::ShiftUpdater.new(in_progress_shift).update

        if notify?
          Notifications::ScheduleUpdatedJob.
            perform_later(in_progress_shift.user_id,
                          Marshal.dump([:shift_changed]))
        end
      end

      def delete_in_progress_shifts
        Shift.
          where(in_progress_shift_id: in_progress_shift.id).
          update_all(deleted_at: DateTime.now)

        if in_progress_shift.repeating? && delete_series?
          repeating_shift = in_progress_shift.repeating_shift

          InProgressShift.
            where(repeating_shift_id: repeating_shift.id).
            update_all(deleted_at: DateTime.now)

          Shift.
            where(repeating_shift_id: repeating_shift.id).
            update_all(deleted_at: DateTime.now)

          repeating_shift.update(deleted_at: DateTime.now)
        end

        if notify?
          Notifications::ScheduleUpdatedJob.
            perform_later(in_progress_shift.user_id,
                          Marshal.dump([:shift_cancelled]))
        end
      end

      def delete_series?
        @delete_series
      end

      def deleted?
        in_progress_shift.deleted?
      end

      def active_shift
        Shift.find_by(location_id: in_progress_shift.location_id,
                      in_progress_shift_id: in_progress_shift.id)
      end

      def notify?
        notify && published?
      end

      def published?
        in_progress_shift.published?
      end

      def repeating?
        in_progress_shift.repeating?
      end

      def shift_params
        in_progress_shift.
          slice(:minute_start,
                :minute_end,
                :date,
                :location_id,
                :repeating_shift_id,
                :user_id).
          merge(in_progress_shift_id: in_progress_shift.id)
      end

      attr_reader :in_progress_shift, :notify
    end
  end
end
