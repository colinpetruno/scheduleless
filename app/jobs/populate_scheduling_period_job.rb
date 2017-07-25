class PopulateSchedulingPeriodJob < ApplicationJob
  queue_as :default

  def perform(scheduling_period_id)
    @scheduling_period = SchedulingPeriod.find(scheduling_period_id)

    sleep(3)
    @scheduling_period.update_column(status: 6)
    # TODO: add action cable
    # TODO: CJ - add in populate work
    sleep(3)

    @scheduling_period.update_column(status: 1)
    # TODO: Action Cable stuff
  end
end
