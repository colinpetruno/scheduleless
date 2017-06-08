namespace :scheduling do
  desc "Seed a demo account, rake database:seed_demo[demo1]"
  task :schedule_period_closer => [:environment] do |t, args|
    SchedulePeriodCloser.perform
  end
end
