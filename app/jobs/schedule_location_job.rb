class ScheduleLocationJob < ApplicationJob
  queue_as :default

  def perform(schedule_period_id)
    schedule_period = SchedulePeriod.find(schedule_period_id)

    scheduler = Schedule.new(company: company, location: location)
    schedule.schedule

    # Scheduler::Schedule.for(company, location, start_day, day_range, time_range)
  end
end
