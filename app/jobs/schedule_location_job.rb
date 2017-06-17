class ScheduleLocationJob < ApplicationJob
  queue_as :default

  def perform(schedule_period_id)
    @scheduling_period = SchedulingPeriod.find(schedule_period_id)

    if scheduleable?
      scheduler = Scheduler::Schedule.for(@scheduling_period)
      scheduler.generate
    end

    @scheduling_period.update(status: completed_status)
  end

  private

  def company
    @scheduling_period.company
  end

  def completed_status
    if company.demo?
      :scheduleless_approved
    else
      :generated
    end
  end

  def location
    @scheduling_period.location
  end

  def scheduleable?
    # TODO: can add more error checking in here for known failure cases
    location.users.exists?
  end
end
