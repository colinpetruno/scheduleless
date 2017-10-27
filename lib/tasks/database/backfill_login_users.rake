namespace :database do
  desc "Ensure Login users Are Created For All users"
  task :backfill_login_users => :environment do
    Chewy.strategy(:atomic) do
      User.where("email is not null").each do |user|
        user.save
      end
    end
  end
end
