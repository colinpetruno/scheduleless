module Scheduler
  class TimeslotReader

    def initialize(date_start:, timeoff_requests:, options:)
      @date_start = date_start
      @timeoff_requests = timeoff_requests
      @options = options
    end

    def time_not_during_timeoff?(timeslot, employee)

      timeslot_date = date_start + timeslot.x.days
      timeslot_time = timeslot.y * options.time_interval_minutes


      # Find all requests that are approved and within constraints
      timeoff_requests_matching = timeoff_requests.detect do |timeoff|
        day_off_distance = timeoff.end_date - timeoff.start_date

        day_within_bounds = timeoff.user_id == employee.id &&
          timeslot_date >= Date.parse(timeoff.start_date.to_s) &&
          timeslot_date <= Date.parse(timeoff.end_date.to_s) if day_off_distance > 0 &&
          timeoff.approved?

        if timeoff.start_minutes.nil? and timeoff.end_minutes.nil?
          day_within_bounds
        else
          # if time is factored in - check minutes on the same day
          time_within_bounds = timeslot_time >= timeoff.start_minutes if timeoff.start_minutes &&
            timeslot_time < timeoff.end_minutes if timeoff.end_minutes

          day_within_bounds && time_within_bounds
        end
      end

      # If there are no timeoff requests conflicting - then timeslot is free
      timeoff_requests_matching.nil?
    end

    private

    attr_reader :date_start
    attr_reader :timeoff_requests
    attr_reader :options

  end
end
