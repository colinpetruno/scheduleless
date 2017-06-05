class SchedulePeriodOptions
  def self.for(location)
    new(location: location).options
  end

  def initialize(location:)
    @location = location
  end

  def options
    [transition_period, next_period_start].compact
  end

  private

  attr_reader :location

  def current_period
    # TODO: this is prone to timezone issues, may or may not be an issue
    @_current_period ||= find_current_period
  end

  def find_current_period
    location.
      scheduling_periods.
      where("start_date <= ? and end_date >= ?",
            Date.today.to_s(:integer),
            Date.today.to_s(:integer))
  end

  def transition_period
    if current_period.present?
      nil
    else
      [transition_label, Date.today.to_s(:integer)]
    end
  end

  def transition_period_end_date
    next_date_for(schedule_setting.start_day_of_week) - 1.day
  end

  def transition_period_end
    transition_period_end_date.to_s(:integer).to_i
  end

  def next_period_start
    if current_period.present?
      start_date = current_period.first.end_date + 1
    else
      start_date = transition_period_end_date + 1.day
    end

    [next_period_label(start_date), start_date]
  end

  def next_period_label(start_date)
    start = Date.parse(start_date.to_s)
    end_date =  start + (schedule_setting.schedule_duration * 7).days - 1.day

    "#{start.to_s(:month_day_year)} - #{end_date.to_s(:month_day_year)}"
  end

  def transition_label
    "#{Date.today.to_s(:month_day_year)} - #{transition_period_end_date.to_s(:month_day_year)}"
  end

  def next_date_for(day)
    date  = Date.parse(day)
    # if the start day of the schedule is today, then use the full duration
    delta = date > Date.today ? 0 : (schedule_setting.schedule_duration * 7)
    date + delta
  end

  def company
    location.company
  end

  def schedule_setting
    company.schedule_setting
  end
end
