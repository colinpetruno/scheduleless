class SchedulingPeriodShowPresenter
  attr_reader :date

  def initialize(scheduling_period, date = nil)
    @date = date
    @scheduling_period = scheduling_period
  end

  def location
    scheduling_period.location
  end

  def day_to_open
    date || day_keys.first
  end

  def shifts
    scheduling_period.in_progress_shifts.includes(:user)
  end

  def shifts_for(day)
    shifts_by_day_hash[day.to_i]
  end

  def day_keys
    (start_date..end_date).map { |date| date.to_s(:integer).to_i }
  end

  private

  attr_reader :scheduling_period

  def build_shift_hash
    day_keys.inject({}) do |object, day|
      object[day] = shifts.select { |shift| shift.date == day }
      object
    end
  end

  def end_date
    Date.parse(scheduling_period.end_date.to_s)
  end

  def shifts_by_day_hash
    @_shifts_by_day_hash ||= build_shift_hash
  end

  def start_date
    Date.parse(scheduling_period.start_date.to_s)
  end
end
