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
        repeating_shift.update(preview_position_id: params[:position_id],
                               preview_user_id: params[:user_id],
                               repeat_frequency: params[:repeat_frequency])


        seeded_shifts.each do |shift|
          if invalid?(shift)
            # delete the inprogress shift out of the database, this is so
            # if the shift changes back to an old frequency that the shift
            # can get repopulated
            shift.delete
          else
            Shifts::Updater.
              update(
                shift,
                {
                  minute_start: repeating_shift.preview_minute_start,
                  minute_end: repeating_shift.preview_minute_end,
                  position_id: repeating_shift.preview_position_id,
                  user_id: repeating_shift.preview_user_id
                }
              )
          end
        end


      end
    rescue StandardError => error
      Bugsnag.notify(error)
      false
    end

    private

    attr_reader :repeating_shift

    def seeded_shifts
      InProgressShift.where(repeating_shift_id: repeating_shift.id)
    end

    def invalid?(shift)
      offset = shift.date - repeating_shift.start_date

      offset % repeating_shift.repeat_frequency != 0
    end
  end
end
