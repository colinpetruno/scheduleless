class SchedulePeriodRegenerator
  def self.for(scheduling_period, perform_async=true)
    new(scheduling_period: scheduling_period, perform_async: perform_async)
  end

  def initialize(scheduling_period:, perform_async: true)
    @perform_async = perform_async
    @scheduling_period = scheduling_period
  end

  def regenerate
    scheduling_period.in_progress_shifts.delete_all

    if perform_async
      ScheduleLocationJob.perform_later(scheduling_period.id, false)
    else
      ScheduleLocationJob.new.perform(scheduling_period.id, false)
    end
  end

  private

  attr_reader :perform_async, :scheduling_period
end
