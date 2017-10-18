module Shifts
  module Publishers
    class RepeatingShift
      def initialize(repeating_shift:, all: true, start_date: Date.today, end_date: Date.today)
        @repeating_shift = repeating_shift
        @all = all
        @start_date = start_date
        @end_date = end_date
      end

      def publish
        ActiveRecord::Base.transaction do
          update_repeating_shift
          update_in_progress_shifts
        end
      end

      private

      attr_reader :repeating_shift, :start_date, :end_date

      def all_dates?
        @all
      end

      def update_in_progress_shifts
        repeating_shift.
          in_progress_shifts.
          where(date: date_ranges).
          update_all(minute_end: repeating_shift.preview_minute_end,
                     minute_start: repeating_shift.preview_minute_start,
                     position_id: repeating_shift.preview_position_id,
                     user_id: repeating_shift.preview_user_id,
                     published: true,
                     edited: false)
      end

      def date_ranges
        if all_dates?
          # TODO: could cause weird bugs at odd times, use location date instead
          # of start date
          ((Date.today - 1.day).to_s(:integer).to_i..Float::INFINITY)
        else
          (start_date.to_s(:integer).to_i..end_date.to_s(:integer).to_i)
        end
      end


      def update_repeating_shift
        repeating_shift.
          update(minute_end: repeating_shift.preview_minute_end,
                 minute_start: repeating_shift.preview_minute_start,
                 location_id: repeating_shift.preview_location_id,
                 repeat_frequency: repeating_shift.preview_repeat_frequency,
                 position_id: repeating_shift.preview_position_id,
                 published: true,
                 start_date: repeating_shift.preview_start_date,
                 user_id: repeating_shift.preview_user_id)
      end
    end
  end
end
