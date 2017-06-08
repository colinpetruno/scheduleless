namespace :scheduling do
  desc "Close Out Any Old Schedule Periods and Send Reporting"
  task :schedule_period_closer => [:environment] do |t, args|
    SchedulePeriodCloserTask.perform
  end
end
