namespace :scheduling do
  desc "Ensure Locations are Scheduled to their Buffer"
  task :schedule_period_buffer_task => [:environment] do |t, args|
    SchedulingPeriodBufferTask.perform
  end
end
