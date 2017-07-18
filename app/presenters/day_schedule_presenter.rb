class DaySchedulePresenter
  include ActionView::Helpers::UrlHelper

  attr_reader :day, :location, :preview, :shifts

  def initialize(day:, location:, shifts:, preview: false)
    @day = day
    @location = location
    @shifts = shifts.sort_by{ |obj| obj.minute_start }
    @preview = preview
  end

  def delete_shift_route(shift)
    if preview
      routes.
        locations_location_in_progress_shift_path(
          shift.location,
          shift
        )
    else
      routes.
        locations_location_shift_path(shift.location, shift)
    end
  end

  def edit_shift_route(shift)
    if preview
      routes.
        edit_locations_location_in_progress_shift_path(shift.location, shift)
    else
      routes.edit_locations_location_shift_path(shift.location, shift)
    end
  end

  def end_hour
    if !last_shift_minute
      nil
    else
      end_time = [
        hours.minute_schedulable_end,
        last_shift_minute
      ].sort.last

      MinutesToTime.new(minutes: end_time).next_hour
    end
  end

  def formatted_minutes_for(shift)
    "#{MinutesToTime.for(shift.minute_start)} - #{MinutesToTime.for(shift.minute_end)}"
  end

  def hours_to_draw
    if end_hour and start_hour
      (end_hour - start_hour).to_i / 3600
    else
      24/3600
    end
  end

  def manage_shift?(user, shift)
    # TODO: could check against internal location to prevent n+1
    UserPermissions.for(user).manage?(shift.location)
  end

  def start_hour
    if !first_shift_minute
      nil
    else
      start_time = [
        hours.minute_schedulable_start,
        first_shift_minute
      ].sort.first

      MinutesToTime.new(minutes: start_time).start_of_hour
    end
  end

  def next_day
    (day_date + 1.day).strftime('%m/%d/%Y')
  end

  def shift_style(shift)
    if start_hour

      shift_width = shift.minute_end - shift.minute_start
      if shift.minute_end < shift.minute_start
        shift_width = overnight_minute_end(shift.minute_end) - shift.minute_start
      end

      left = ((shift.minute_start / 15) - (start_hour.hour * 60 / 15)) * 10
      width = (shift_width) / 15 * 10

      "left: #{left}px; width: #{width}px"
    else
      "left: 0px; width: 0px"
    end
  end

  private

  def day_date
    Date.parse(day.to_s)
  end

  def overnight_minute_end(mod_minute)
    mod_minute + (24*60)
  end

  def first_shift_minute
    first_shift = shifts.sort_by{ |obj| obj.minute_start }.first
    first_shift.minute_start if first_shift
  end

  def last_shift_minute
    last_shift = find_latest_shift #shifts.sort_by{ |obj| obj.minute_end }.last
    minute = last_shift.minute_end if last_shift

    if minute < last_shift.minute_start
      minute = overnight_minute_end(minute)
    end

    minute
  end

  def find_latest_shift
    latest = shifts.first
    latest_shift_end_minute = latest.minute_end
    if latest.minute_end < latest.minute_start
      latest_shift_end = overnight_minute_end(latest.minute_end)
    end

    shifts.each do |shift|
      shift_end = shift.minute_end
      if shift.minute_end < shift.minute_start
        shift_end = overnight_minute_end(shift_end)
      end

      if latest_shift_end_minute < shift_end
        latest_shift_end_minute = shift_end
        latest = shift
      end
    end

    latest
  end

  def day_integer
    day_date.wday
  end

  def hours
    @_hours ||= location.
      scheduling_hours.
      select{ |hour| hour.day == day_integer }.first
  end

  def routes
    Rails.application.routes.url_helpers
  end
end
