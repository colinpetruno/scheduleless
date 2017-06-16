class ScheduleSettingUpdater
  include ActiveModel::Model

  attr_accessor :company, :lead_time, :note, :schedule_duration, :start_date

  def self.for(params)
    new(params)
  end

  def update
    company.schedule_setting.update(schedule_setting_params)
    create_scheduling_periods

    true
  rescue
    false
  end

  private

  def create_scheduling_periods
    if company.scheduling_periods.blank?
      company.locations.map do |location|
        begin
          scheduling_period = company.
            scheduling_periods.
            create(
              location_id: location.id,
              start_date: start_date_date.to_s(:integer).to_i,
              status: :empty
            )

          ScheduleLocationJob.perform_later(scheduling_period.id)
        rescue StandardError => error
          Bugsnag.notify(error)
        end
      end
    end
  end

  def schedule_setting_params
    {
      day_start: start_date_date.wday,
      lead_time: lead_time,
      note: note,
      schedule_duration: schedule_duration
    }
  end

  def start_date_date
    Date.parse(start_date)
  end
end
