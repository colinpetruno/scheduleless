namespace :database do
  desc "Backfill locations that don't have scheduling hours"
  task :backfill_location_scheduling_hours => :environment do
    Location.all.each do |location|
      if location.scheduling_hours.blank?
        location.send(:build_scheduling_hours)
        location.save
      end
    end
  end
end
