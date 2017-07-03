class UserStreamCalendar
  require "icalendar/tzinfo"

  def self.for(user)
    new(user: user)
  end

  def initialize(user:)
    @user = user

    add_events
  end

  def publish
    calendar.to_ical
  end

  def calendar
    @_calendar ||= Icalendar::Calendar.new
  end

  private

  attr_reader :user

  def add_events
    shifts.each do |shift|
      add_shift_to_calendar(shift)
    end
  end

  def add_shift_to_calendar(shift)
    shift_datetime = ShiftDateTime.for(shift)

    tz =  Time.find_zone(shift_datetime.timezone).tzinfo
    timezone = tz.ical_timezone shift_datetime.start
    calendar.add_timezone timezone

    calendar.event do |e|
      e.dtstart = Icalendar::Values::DateTime.
        new(shift_datetime.start, "tzid": shift_datetime.timezone)
      e.dtend = Icalendar::Values::DateTime.
        new(shift_datetime.end, "tzid": shift_datetime.timezone)

      e.summary     = summary
      e.description = description_for(shift)
      e.ip_class    = "PRIVATE"

      # TODO Localize based on user preferences
      e.alarm do |a|
        a.summary = "You have a shift scheduled soon!"
        a.trigger = "-PT60M"
      end

    end
  end

  def description_for(shift)
    AddressFormatter.for(shift.location).calendar_stream
  end

  def shifts
    @_shifts ||= ShiftFinder.for(user).for_stream.find
  end

  def summary
    user.company.name
  end
end
