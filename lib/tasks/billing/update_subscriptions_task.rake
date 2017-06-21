namespace :billing do
  desc "Update all companies billing info nightly"
  task :update_subscriptions => :environment do
    Chewy.strategy(:atomic) do
      Billing::UpdateSubscriptionsTask.perform 
    end
  end
end
