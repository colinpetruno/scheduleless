module Billing
  class UpdateSubscriptionsTask < CronJob
    def self.perform
      new.perform
    end

    def perform
      super do
        Company.all.each do |company|
          SubscriptionUpdaterJob.perform_later company.id
        end
      end
    end
  end
end
