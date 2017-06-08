class SchedulingPeriodBufferTask < CronJob
  def self.perform
    new.perform
  end

  def perform
    super do
      company_batches.with_index do |batch, index|
        log("Processing Batch #{index}")
        process(batch)
      end
    end
  end

  private

  def company_batches
    companies.find_in_batches(batch_size: 100)
  end

  def companies
    # TODO: Filter to active only
    Company.all.includes(:schedule_setting)
  end

  def connection
    @_connection ||= prepare_connection
  end

  def execute_query(date, company_id, count)
    connection.
      exec_prepared("too_few_scheduling_periods", [date, company_id, count])
  end

  def prepare_connection
    connection = ActiveRecord::Base.connection.raw_connection
    connection.prepare("too_few_scheduling_periods", query)
    connection
  rescue PG::DuplicatePstatement
    connection
  end

  def process(batch)
    batch.each do |company|
      schedule_setting = company.schedule_setting

      locations_to_schedule = execute_query(
        Date.today.to_s(:integer).to_i,
        company.id,
        schedule_setting.lead_time
      )

      queue_locations(locations_to_schedule)
    end
  end

  def query
    <<-QUERY
      select l.id, count(1) from locations l
      left join scheduling_periods sp on l.id = sp.location_id and sp.start_date > $1
      where l.company_id = $2
      group by l.id
      having count(1) < $3;
    QUERY
  end

  def queue_locations(locations)
    # [{"id"=>26, "count"=>1}] example format passed into this function
    locations.map do |location|
      log("Queuing CreateSchedulePeriodsJob for location #{location["id"]}")
      # CreateSchedulePeriodsJob.perform_later location["id"]
    end
  end
end
