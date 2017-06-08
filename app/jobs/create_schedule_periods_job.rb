class CreateSchedulePeriodsJob < ApplicationJob
  queue_as :default

  def perform(location_id)
    @location = Location.find(location_id)

    build_scheduling_periods_to_buffer
  end

  private

  attr_reader :location

  def build_scheduling_periods_to_buffer
    ((scheduling_period_count + 1)..schedule_setting.lead_time).each do |i|
      @last_scheduling_period = location.
        scheduling_periods.
        create(
          company_id: location.company_id,
          start_date: next_day_integer(last_scheduling_period.end_date),
          status: :empty
        )

      # ScheduleLocationJob.perform_later @last_scheduling_period.id
    end
  end

  def company
    location.company
  end

  def date_integer
    # this is all over the app, consolidate to a date class
    Date.today.to_s(:integer).to_i
  end

  def find_or_build_last_period
    location.scheduling_periods.order(end_date: :desc).first ||
      location.scheduling_periods.build(end_date: Date.today.to_s(:integer).to_i)
  end

  def next_day_integer(date_integer)
    date = Date.parse(date_integer.to_s)
    next_date = date + 1.day
    next_date.to_s(:integer).to_i
  end

  def last_scheduling_period
    @last_scheduling_period ||= find_or_build_last_period
  end

  def schedule_setting
    company.schedule_setting
  end

  def scheduling_period_count
    location.
      scheduling_periods.
      where(start_date: (date_integer..Float::INFINITY)).
      size
  end
end
