module Shifts
  module Publishers
    class DateRange
      def initialize(end_date: Date.today,
                     location:,
                     all_shifts: true,
                     notify: true,
                     start_date: Date.today)
        @end_date = end_date.is_a?(Date) ? end_date : Date.parse(end_date.to_s)
        @all_shifts = all_shifts
        @location = location
        @notify = notify
        @start_date = start_date.is_a?(Date) ? start_date : Date.parse(start_date.to_s)
      end

      def publish
        ActiveRecord::Base.transaction do
          # publish_deleted_shifts
          # hiding this for now because deleted shifts should instantly be
          # published
          publish_active_shifts
          publish_new_shifts
        end

        send_notifications
      end

      private

      attr_reader :end_date, :location, :notify, :start_date

      def all_shifts?
        if [true, "true"].include?(@all_shifts)
          true
        else
          false
        end
      end

      def base_scope
        InProgressShift.
          where(date: date_range,
                edited: true,
                location_id: location.id).
          where("user_id is not null and position_id is not null")
      end

      def date_range
        (start_date.to_s(:integer).to_i..end_date.to_s(:integer).to_i)
      end

      def active_shifts
        base_scope.where(published: true)
      end

      def deleted_shifts
        base_scope.
          unscoped.
          where(edited: true).
          where("deleted_at is not null")
      end

      def new_shifts
        base_scope.where(published: false, deleted_at: nil)
      end

      def publish_deleted_shifts
        deleted_shifts.each do |deleted_shift|
          # delete all published shifts
          if deleted_shift.published?
            deleted_shift.shifts.update_all(deleted_at: DateTime.now)
            add_notification(deleted_shift.user_id, :shift_deleted)
          end

          # delete the repeating shift
          if deleted_shift.repeating?
            if deleted_shift.reload&.repeating_shift&.preview_deleted_at.present?
              deleted_shift.
                repeating_shift.
                update(deleted_at: DateTime.now)
            end
          end
        end

        deleted_shifts.update(edited: false, published: true)
      end

      def publish_active_shifts
        active_shifts.each do |active_shift|
          if active_shift.repeating?
            repeating_shift = active_shift.repeating_shift

            Shifts::Publishers::RepeatingShift.
              new(repeating_shift: repeating_shift,
                  all: all_shifts?,
                  start_date: start_date,
                  end_date: end_date).
              publish
          end

          updater = Utilities::ShiftUpdater.new(active_shift)

          updater.update

          updater.notifications.each do |notification|
            add_notification(notification.first, notification.last)
          end
        end

        active_shifts.update_all(edited: false, published: true)
      end

      def publish_new_shifts
        new_shifts.each do |new_shift|
          Utilities::ShiftCreator.create_from(new_shift)

          if new_shift.repeating?
            Shifts::Publishers::RepeatingShift.
              new(repeating_shift: new_shift.repeating_shift.reload,
                  all: all_shifts?,
                  start_date: start_date,
                  end_date: end_date).
              publish
          end

          add_notification(new_shift.user_id, :shift_added)
        end

        new_shifts.update_all(edited: false, published: true)
      end

      def add_notification(user_id, notification)
        if notifications[user_id].blank?
            notifications[user_id] = []
        end

        notifications[user_id].push(notification)
      end

      def notifications
        # {20=>[:shift_added], 308=>[:shift_added], 17=>[:shift_added]}
        # {308=>[:shift_deleted, :shift_added, :shift_added], 20=>[:shift_added]}
        # :shift_added, :shift_cancelled, :shift_changed
        @_notifications ||= {}
      end

      def send_notifications
        notifications.each do |user_id, notifications|
          Notifications::ScheduleUpdatedJob.
            perform_later(user_id, Marshal.dump(notifications))
        end
      end
    end
  end
end
