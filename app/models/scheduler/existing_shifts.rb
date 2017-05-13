module Scheduler
  class ExistingShifts
    def initialize(company, date_start, options, timeslot_minute_range=15)
      @date_start = date_start.strftime('%Y%m%d').to_i
      @shifts = Shift.where("date >= #{@date_start}", company_id: company.id)
      @options = options
      @timeslot_minute_range = timeslot_minute_range
      parse_shifts
    end

    def user_scheduled_at(user_id, x, y)
      timeslot_id = "#{x},#{y}"
      if existing_timeslots.key? timeslot_id
        existing_timeslots[timeslot_id].any? {|e| e[:user_id] == user_id}
      else
        false
      end
    end

    # check if the user is scheduled at all during the day
    #   Optionally - exclude_location to check if user is scheduled at a location other than the excluded
    def user_scheduled_during_day(user_id, x, exclude_location=nil)
      (0..@options.number_of_intervals).each do |y|
        timeslot_id = "#{x},#{y}"
        if existing_timeslots.key? timeslot_id
          if existing_timeslots[timeslot_id].any? {|e| e[:user_id] == user_id and (exclude_location.nil? or e[:location_id] != exclude_location)}
            return true
          end
        end
      end
      false
    end

    private

    def parse_shifts
      @shifts.each do |shift|
        x = get_day_integer(shift.date)

        y_start = get_time_integer(shift.minute_start)
        y_end = get_time_integer(shift.minute_end)-1

        (y_start..y_end).each do |y|
          timeslot_id = "#{x},#{y}"
          user_id = shift.user_id

          if existing_timeslots.key? timeslot_id
            existing_timeslots[timeslot_id].push({user_id: user_id, location_id: shift.location_id}) unless existing_timeslots[timeslot_id].any? {|e| e[:user_id] == user_id and e[:location_id] == shift.location_id}
          else
            existing_timeslots[timeslot_id] = [{user_id: user_id, location_id: shift.location_id}]
          end
        end
      end
    end

    def get_day_integer (date_integer)
      date_integer - @date_start
    end

    def get_time_integer (minute_start)
      minute_start/@timeslot_minute_range
    end

    def existing_timeslots
      @_existing_timeslots ||= {}
    end

  end
end