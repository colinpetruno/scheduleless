class ScheduleLocationJob < ApplicationJob
  queue_as :default

  def perform(schedule_period_id)
    scheduling_period = SchedulingPeriod.find(schedule_period_id)
    company = scheduling_period.company
    location = scheduling_period.location
    schedule_setting = company.schedule_setting
    start_day = Date.parse(scheduling_period.start_date.to_s)

    day_range = schedule_setting.schedule_duration * 7
    time_range = 4

    scheduler = Scheduler::Schedule.for(
      company,
      location,
      start_day,
      day_range,
      time_range
    )

    scheduler.generate
  end
end
