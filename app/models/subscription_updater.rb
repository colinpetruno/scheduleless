class SubscriptionUpdater
  def self.for(subscription)
    new(subscription: subscription)
  end

  def initialize(subscription:)
    @subscription = subscription
  end

  def update(params)
    # TODO: if stripe subscription update fails we want to roll back the update
    # perhaps put this in a transaction would work?
    subscription.update(params)
    StripeSubscription.for(subscription).update

    true
  rescue
    # TODO: ERROR HEREEE
    false
  end

  private

  attr_reader :subscription
end
