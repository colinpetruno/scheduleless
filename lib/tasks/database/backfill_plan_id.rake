namespace :database do
  desc "Create plan and Backfill plan_id with plan value"
  task :backfill_plan_id => :environment do

    Plan.new({id: 1, plan_name: "regular"}).save

    Chewy.strategy(:atomic) do
      Subscription.all.each do |subscription|
        if subscription.plan_id.blank?
          subscription.plan_id = subscription.plan
          subscription.save
        end
      end
    end
  end
end
