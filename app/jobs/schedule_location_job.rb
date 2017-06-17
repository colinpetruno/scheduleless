class ScheduleLocationJob < ApplicationJob
  queue_as :default

  def perform(schedule_period_id)
    @scheduling_period = SchedulingPeriod.find(schedule_period_id)
    company = @scheduling_period.company
    schedule_setting = company.schedule_setting

    if scheduleable?
      scheduler = Scheduler::Schedule.for(@scheduling_period)
      scheduler.generate
    end

    @scheduling_period.update(status: :generated)
  end

  private

  def location
    @scheduling_period.location
  end

  def scheduleable?
    # TODO: can add more error checking in here for known failure cases
    location.users.exists?
  end
end
