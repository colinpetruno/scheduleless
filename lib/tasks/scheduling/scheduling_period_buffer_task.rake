namespace :scheduling do
  desc "Ensure Locations are Scheduled to their Buffer"
  task :schedule_period_closer => [:environment] do |t, args|
    SchedulingPeriodBufferTask.perform
  end
end
