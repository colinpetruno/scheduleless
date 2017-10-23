namespace :database do
  desc "Backfill check ins"
  task :backfill_check_ins => :environment do
    Chewy.strategy(:atomic) do
      CheckIn.all.includes(:shift) do |check_in|
        check_in.user_id = check_in.shift.user_id
        check_in.location_id = check_in.shift.location_id

        check_in.save
      end
    end
  end
end
