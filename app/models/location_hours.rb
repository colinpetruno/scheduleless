class LocationHours
  DAYS = {
    sunday: 0,
    monday: 1,
    tuesday: 2,
    wednesday: 3,
    thursday: 4,
    friday: 5,
    saturday: 6
  }

  def self.for(location)
    new(location: location)
  end

  def initialize(location:)
    @location = location
  end

  def close(day)
    scheduling_hour_for(day).minute_schedulable_end
  rescue
    1440
  end

  def closed?
    !open?
  end

  def closing
    if open?
      MinutesToTime.for(current_scheduling_hour.last.minute_open_end).to_s
    end
  end

  def current_time
    location_time.current_time
  end


  def open(day)
    scheduling_hour_for(day).minute_schedulable_start
  rescue
    0
  end

  def open?
    current_scheduling_hour.exists?
  end

  def opening
    # TODO break into its on class and provide better ways of
    # returning the date. Allow formmated string to be passed etc

    # order the hours according to day and find the index of the current day
    offset_index = scheduling_hours.find_index do |scheduling_hour|
      scheduling_hour.day == current_day_integer
    end

    # rotate the array to start the array with the current day index
    # binding.pry
    ordered_hours = scheduling_hours.to_a.rotate(offset_index)

    # if the open minute is already past then the location does not open today
    # and we should get tomorrows opening
    if ordered_hours.first.minute_open_start > current_time_minutes
      next_open_hour = ordered_hours.first
    else
      next_open_hour = ordered_hours.second
    end

    open_time = MinutesToTime.for(next_open_hour.minute_open_start).to_s
    open_date = DateAndTime::Navigator.
      new(current_date: current_time).
      date_of_next(next_open_hour.day)

    "#{open_date.to_s(:month_day)} at #{open_time}"
  end

  private

  attr_reader :location

  def current_date_integer
    location_time.current_date_integer
  end

  def current_day_integer
    location_time.current_day_integer
  end

  def current_scheduling_hour
    SchedulingHour.
      where(location_id: location.id, day: current_day_integer).
      where("minute_open_start < ?", current_time_minutes).
      where("minute_open_end > ?", current_time_minutes)
  end

  def current_time_minutes
    location_time.current_time_minutes
  end

  def location_time
    @_time ||= DateAndTime::LocationTime.new(location: location)
  end

  def scheduling_hours
    SchedulingHour.where(location_id: location.id).order(:day)
  end

  def scheduling_hour_for(day)
    SchedulingHour.find_by(location_id: location.id, day: day)
  end
end
