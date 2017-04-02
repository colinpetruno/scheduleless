class Schedule
  include ActiveModel::Model

  attr_accessor :company

  def schedule
    @_schedule ||= create_schedule
  end

  def shifts
    if @_shifts.present?
      @_shifts
    else
      generate_schedule
      @_shifts = schedule.shifts
    end
  end

  private

  def create_schedule
    Scheduler::Schedule.for(company)
  end

  def generate_schedule
    schedule.generate
  end
end