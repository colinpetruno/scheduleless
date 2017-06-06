class SchedulePeriodRegenerator
  def self.for(scheduling_period)
    new(scheduling_period: scheduling_period)
  end

  def initialize(scheduling_period:)
    @scheduling_period = scheduling_period
  end

  def regenerate
    scheduling_period.in_progress_shifts.delete_all
    ScheduleLocationJob.new.perform(scheduling_period.id)
  end

  private

  attr_reader :scheduling_period
end
