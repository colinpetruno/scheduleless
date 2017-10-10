module Shifts
  module Publishers
    module Utilities
      class ShiftUpdater
        def initialize(in_progress_shift)
          @in_progress_shift = in_progress_shift
        end

        def changed?
          changes.present?
        end

        def changes
          # {
          #   "minute_start"=>[540, 510],
          #   "minute_end"=>[990, 960],
          #   "user_id"=>[18, 2]
          # }
          # first is original, second is updated
          @changes ||= record_changes
        end

        def notifications
          @_notifications ||= build_notifications
        end

        def update
          @changes ||= record_changes

          shifts.update_all(shift_params)
        end

        private

        attr_reader :in_progress_shift

        def build_notifications
          not_array = []

          if changed?
            if changes[:user_id].present?
              not_array.push([changes[:user_id].first, :shift_cancelled])
              not_array.push([changes[:user_id].last, :shift_added])
            end

            if changes[:minute_start].present? || changes[:minute_end].present? ||
                 changes[:date].present? || changes[:location_id].present?
              not_array.push([in_progress_shift.user_id, :shift_changed])
            end
          end

          not_array
        end

        def record_changes
          shift = shifts.first
          shift.assign_attributes(shift_params)

          shift.changes
        end

        def shifts
          in_progress_shift.shifts
        end

        def shift_params
          in_progress_shift.
            slice(:company_id,
                  :minute_start,
                  :minute_end,
                  :date,
                  :location_id,
                  :repeating_shift_id,
                  :user_id).
            merge(in_progress_shift_id: in_progress_shift.id)
        end

      end
    end
  end
end
