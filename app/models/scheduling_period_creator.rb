class SchedulingPeriodCreator
  def self.for(location, date)
    new(date: date, location: location)
  end

  def initialize(date:, location:, populate: false)
    @date = date
    @location = location
    @populate = populate
  end

  def create
    scheduling_period = SchedulingPeriod.create(
      company_id: location.company_id,
      location_id: location.id,
      start_date: start_date.to_s(:integer).to_i,
      end_date: end_date.to_s(:integer).to_i,
      status: status
    )

    if populate
      PopulateSchedulingPeriodJob.perform_later scheduling_period.id
    end

    scheduling_period
  end

  private

  attr_reader :date, :location, :populate

  def company
    location.company
  end

  def current_weekday
    date.wday
  end

  def period_start_date
    date - (current_weekday - start_day).days
  end

  def end_date
    start_date + schedule_setting.schedule_duration.weeks - 1.day
  end

  def base_period
    SchedulingPeriod.
      where(company_id: location.company_id, location_id: location.id).
      order(:end_date).
      first
  end

  def last_end_date
    Date.parse(base_period.end_date.to_s)
  end

  def offset_periods
    (offset_weeks / schedule_setting.schedule_duration).to_i
  end

  def offset_weeks
    ((period_start_date - (last_end_date + 1.day)) / 7).to_i
  end

  def schedule_setting
    company.schedule_setting
  end

  def start_day
    schedule_setting.day_start
  end

  def start_date
    (last_end_date + 1.day) + (offset_periods * schedule_setting.schedule_duration).weeks
  end

  def status
    if populate == "true"
      :empty
    else
      :generated
    end
  end
end
