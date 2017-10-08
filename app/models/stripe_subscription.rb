class StripeSubscription
  def self.for(subscription)
    new(subscription: subscription)
  end

  def initialize(subscription:)
    @subscription = subscription
  end

  def create
    @stripe_subscription ||= find_stripe_subscription
  end

  def retrieve
    @stripe_subscription ||= find_stripe_subscription
  end

  def update(quantity)
    stripe_subscription.plan = subscription.plan.plan_name.downcase
    stripe_subscription.quantity = quantity
    stripe_subscription.save
  end

  private

  attr_reader :subscription

  def create_stripe_subscription
    return if Rails.env.test?

    stripe_subscription = Stripe::Subscription.create(
      customer: subscription.company.stripe_customer_id,
      plan: (subscription&.plan&.plan_name&.downcase || "standard")
    )

    subscription.update(stripe_subscription_id: stripe_subscription.id)

    subscription
  end

  def find_stripe_subscription
    return if Rails.env.test?

    if subscription.stripe_subscription_id.present?
      retrieve_stripe_subscription
    else
      create_stripe_subscription
    end
  end

  def retrieve_stripe_subscription
    return if Rails.env.test?

    Stripe::Subscription.retrieve(subscription.stripe_subscription_id)
  end

  def stripe_subscription
    @stripe_subscription ||= find_stripe_subscription
  end
end
