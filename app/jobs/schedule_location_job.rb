class ScheduleLocationJob < ApplicationJob
  queue_as :default

  def perform(schedule_period_id)
    scheduling_period = SchedulingPeriod.find(schedule_period_id)
    company = scheduling_period.company
    schedule_setting = company.schedule_setting

    scheduler = Scheduler::Schedule.for(scheduling_period)

    scheduler.generate

    scheduling_period.update(status: :generated)
  end
end
