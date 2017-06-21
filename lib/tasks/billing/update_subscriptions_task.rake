namespace :billing do
  desc "Update all companies billing info nightly"
  task :update_subscriptions => :environment do
    Chewy.strategy(:atomic) do
      Company.all.each do |company|
        SubscriptionUpdaterJob.perform_later company.id
      end
    end
  end
end
