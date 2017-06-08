class SchedulePeriodCloserTask < CronJob
  def self.perform
    new.perform
  end

  def perform
    super do
      scheduling_period_batches.with_index do |batch, index|
        log("Processing Batch #{index}")
        process(batch)
      end
    end
  end

  private

  def process(batch)
    batch.each do |scheduling_period|
      #TODO: QUEUE REPORTING JOB HERE
    end
  end

  def scheduling_period_batches
    scheduling_periods_to_close.find_in_batches(batch_size: 100)
  end

  def scheduling_periods_to_close
    SchedulingPeriod.
      where(end_date: (-Float::INFINITY..Date.today.to_s(:integer).to_i)).
      where.not(status: :closed)
  end
end
