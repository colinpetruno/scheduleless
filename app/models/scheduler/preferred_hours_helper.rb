module Scheduler
  class PreferredHoursHelper

    attr_reader :employee
    attr_reader :timeslot
    attr_reader :options

    def initialize(employee:, timeslot:, options:)
      @employee = employee
      @timeslot = timeslot
      @options = options
    end

    def timeslot_in_preferred_hours
      preferred_hours = employee.preferred_hours

      if preferred_hours.nil?
        return false
      end

      # Check if any of the preferred hours ranges contain the timeslot
      preferred_hours.any? do |ph|
        day_match = ph.day == timeslot.x

        # Translate to a Y coordinate
        ph_start_y = ph.start/options.time_interval_minutes
        ph_end_y = ph.end/options.time_interval_minutes

        # The Days are the same and the timeslot.y is within the start and end times
        day_match and ph_start_y < timeslot.y and timeslot.y < ph_end_y
      end
    end

  end
end