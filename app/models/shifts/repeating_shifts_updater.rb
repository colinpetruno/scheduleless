module Shifts
  class RepeatingShiftsUpdater
    def self.for(repeating_shift)
      new(repeating_shift)
    end

    def initialize(repeating_shift)
      @repeating_shift = repeating_shift
    end

    def update(params)
      ActiveRecord::Base.transaction do
        repeating_shift.update(params)


        seeded_shifts.each do |shift|
          if invalid?(shift)
            # delete shift
          else
            Shifts::Updater.
              for(shift).
              update(position_id: repeating_shift.position_id,
                     user_id: repeating_shift.user_id)
          end
        end


      end
    rescue StandardError => error
      Bugsnag.report(error)
      false
    end

    private

    attr_reader :repeating_shift

    def seeded_shifts
      ShiftInProgress.where(repeating_shift_id: repeating_shift.id)
    end

    def valid?(shift)
      offset = shift.date - repeating_shift.start_date

      offset % repeating_shift.repeat_frequency != 0
    end
  end
end
