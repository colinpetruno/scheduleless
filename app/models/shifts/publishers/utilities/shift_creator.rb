module Shifts
  module Publishers
    module Utilities
      class ShiftCreator
        def self.create_from(in_progress_shift)
          new(in_progress_shift).create
        end

        def initialize(in_progress_shift)
          @in_progress_shift = in_progress_shift
        end

        def create
          Shift.create(shift_params)
        end

        private

        attr_reader :in_progress_shift

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
