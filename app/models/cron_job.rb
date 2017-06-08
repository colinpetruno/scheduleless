class CronJob
  def perform
    create_task_run
    yield
    complete_task_run
  rescue StandardError => error
    Bugsnag.notify(error)

    task_run.update(failed: true,
                    output: error.backtrace,
                    completed_at: DateTime.now)
  end

  private

  def complete_task_run
    task_run.update(output: output.join("\n"), completed_at: DateTime.now)
  end

  def create_task_run
    task_run
  end

  def log(message)
    Rails.logger.info(message)
    output.push(message)
  end

  def output
    @_output ||= []
  end

  def task_run
    @_task_run ||= ScheduledTaskRun.
      create(
        failed: false,
        name: self.class.name,
        started_at: DateTime.now
      )
  end
end
