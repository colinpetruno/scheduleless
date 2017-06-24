module Scheduler
  class ScheduleRuleParser

    attr_reader :layout
    attr_reader :location
    attr_reader :options

    def initialize(layout:, location:, options:)
      @layout = layout
      @location = location
      @options = options
    end

    def open(rule)
      # Add quantity to opening shifts for scheduling hour duration

      (0..options.days_to_schedule).each do |x|
        # Check that the rule day matches this day
        scheduling_day_x = get_scheduling_day(x, location.scheduling_hours.length) #x % location.scheduling_hours.length
        if (!rule.day.nil? and rule.day != scheduling_day_x)
          next
        end

        # Find scheduling hours for this day
        #   Use % of available scheduling hours
        scheduling_hours = location.scheduling_hours.find_by(day: scheduling_day_x)
        if !scheduling_hours
          raise "Missing Scheduling Hours for day #{x}"
        end

        # Open is from open time until preferred length
        y_time_start = (scheduling_hours.minute_schedulable_start || scheduling_hours.minute_open_start)/options.time_interval_minutes
        y_time_end = y_time_start + (preferences.preferred_shift_length/options.time_interval_minutes) - 1

        (y_time_start..y_time_end).each do |y|
          # Add slots to timeslot
          timeslot = layout.get_timeslot(x, y)
          timeslot.add_slots_available(rule[:number_of_employees], rule.position)
        end
      end
    end

    def close(rule)
      # Add quantity to closing shifts for scheduling hour duration

      (0..options.days_to_schedule).each do |x|
        scheduling_day_x = get_scheduling_day(x, location.scheduling_hours.length) #x % location.scheduling_hours.length
        if (!rule.day.nil? and rule.day != scheduling_day_x)
          next
        end
        # Find scheduling hours for this day
        #   Use % of available scheduling hours
        scheduling_hours = location.scheduling_hours.find_by(day: scheduling_day_x)
        if !scheduling_hours
          raise "Missing Scheduling Hours for day #{x}"
        end

        # Close is from end - preferred length until end
        y_time_start = ((scheduling_hours.minute_schedulable_end || scheduling_hours.minute_open_end) - preferences.preferred_shift_length)/options.time_interval_minutes
        y_time_end = ((scheduling_hours.minute_schedulable_end || scheduling_hours.minute_open_end)/options.time_interval_minutes) - 1

        (y_time_start..y_time_end).each do |y|
          # Add slots to timeslot
          timeslot = layout.get_timeslot(x, y)
          timeslot.add_slots_available(rule[:number_of_employees], rule.position)
        end
      end
    end

    def all_day(rule)
      # Add quantity to all shifts for scheduling hour duration

      (0..options.days_to_schedule).each do |x|
        scheduling_day_x = get_scheduling_day(x, location.scheduling_hours.length) #x % location.scheduling_hours.length
        if (!rule.day.nil? and rule.day != scheduling_day_x)
          next
        end

        # Find scheduling hours for this day
        #   Use % of available scheduling hours
        scheduling_hours = location.scheduling_hours.find_by(day: scheduling_day_x)
        if !scheduling_hours
          raise "Missing Scheduling Hours for day #{x}"
        end

        (0..options.number_of_intervals).each do |y|
          if slot_within_hours(y, scheduling_hours)
            # Add slots to timeslot
            timeslot = layout.get_timeslot(x, y)
            timeslot.add_slots_available(rule[:number_of_employees], rule.position)
          end
        end
      end
    end

    def get_scheduling_day(x, length)
      # translate the x into the day of the of the schedule
      # add the base day and take the mod of the number of scheduling hours
      base_day = location.company.schedule_setting.day_start
      (x + base_day) % length
    end

    def preferences
      @_preferences ||= PreferenceFinder.for(location)
    end

    def slot_within_hours(y, hours)
      interval_minutes = y*options.time_interval_minutes
      start_time = hours.minute_schedulable_start || hours.minute_open_start
      end_time = hours.minute_schedulable_end || hours.minute_open_end
      interval_minutes >= start_time && interval_minutes < end_time
    end

  end
end
