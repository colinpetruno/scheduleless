class SchedulingPeriodPublisher
  def self.for(scheduling_period)
    new(scheduling_period: scheduling_period)
  end

  def initialize(scheduling_period:)
    @scheduling_period = scheduling_period
  end

  def publish
    # copy shifts over to shifts table
    ActiveRecord::Base.transaction do
      scheduling_period.in_progress_shifts.map do |shift|
        if valid_shift?(shift)
          company.shifts.create(
            shift.slice(:minute_start, :minute_end, :date, :location_id, :user_id)
          )
        end
      end

      # invite employeees that are in pending state
      EmployeeInviteJob.perform_later(scheduling_period.id)

      # update schedule period as published
      scheduling_period.update(status: :published)

      # TODO: Add alert notifications
    end

    true
  rescue StandardError => error
    Rails.logger.info(error.inspect)
    Bugsnag.notify("Schedule Not Published for id: #{scheduling_period.id}") do |notification|

      notification.severity = "warning"
    end
    Bugsnag.notify(error)

    false
  end

  private

  attr_reader :scheduling_period

  def company
    scheduling_period.company
  end

  def location
    scheduling_period.location
  end

  def valid_shift?(shift)
    LocationTime.for(location).to_s(:day_integer).to_i < shift.date
  end

end
