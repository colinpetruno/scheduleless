class WeekSchedulePresenter
  attr_reader :day, :location, :shifts

  def initialize(day:, location:)
    @day = day
    @location = location
  end

  def days
    (start_day..end_day)
  end

  def start_day
    day.beginning_of_week(:sunday)
  end

  def end_day
    day.end_of_week(:sunday)
  end

  def users
    location.users.order(:family_name)
  end

  def shifts_for(user, date)
    key = "#{user.id}_#{date.to_s(:integer)}"

    shift_map[key]
  end

  private

  def build_shift_map
    map = {}

    shifts.each do |shift|
      key = "#{shift.user_id}_#{shift.date}"
      if map[key].present?
        map[key].push(shift)
      else
        map[key] = [shift]
      end
    end

    map
  end

  def company
    location.company
  end

  def date_integer_range
    (start_day.to_s(:integer).to_i..end_day.to_s(:integer).to_i)
  end

  def shift_map
    @_shift_map ||= build_shift_map
  end

  def shifts
    company.shifts.where(date: date_integer_range, location_id: location.id)
  end
end
