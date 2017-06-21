class SubscriptionUpdaterJob < ApplicationJob
  queue_as :default

  def perform(company_id)
    @company = Company.find(company_id)


    StripeSubscription.for(company.subscription).update(employee_count)
  end

  private

  attr_reader :company

  def employee_count
    @_count ||= company.users.count(1)
  end
end
