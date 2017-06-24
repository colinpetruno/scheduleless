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
    end_time = [
      hours.minute_schedulable_end,
      shifts.sort_by{ |obj| obj.minute_end }.last.minute_end
    ].sort.last

    MinutesToTime.new(minutes: end_time).next_hour
  end

  def formatted_minutes_for(shift)
    "#{MinutesToTime.for(shift.minute_start)} - #{MinutesToTime.for(shift.minute_end)}"
  end

  def hours_to_draw
    (end_hour - start_hour).to_i / 3600
  end

  def manage_shift?(user, shift)
    # TODO: could check against internal location to prevent n+1
    user.manage?(shift.location) || user.company_admin?
  end

  def start_hour
    start_time = [
      hours.minute_schedulable_start,
      shifts.sort_by{ |obj| obj.minute_start }.first.minute_start
    ].sort.first

    MinutesToTime.new(minutes: start_time).start_of_hour
  end

  def shift_style(shift)
    left = ((shift.minute_start / 15) - (start_hour.hour * 60 / 15)) * 10
    width = (shift.minute_end - shift.minute_start) / 15 * 10

    "left: #{left}px; width: #{width}px"
  end


  private

  def day_date
    Date.parse(day.to_s)
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
