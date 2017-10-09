class Subscription < ApplicationRecord
  belongs_to :company
  belongs_to :credit_card
  belongs_to :plan

  after_save :update_stripe_subscription

  def self.collection_labels
    self.plans.keys.map do |key|
      [I18n.t("models.subscription.#{key}"), key]
    end
  end

  def plan_id
    if super.present?
      super
    else
      plan = Plan.find_by(default: true)
      self.update_attribute(:plan_id, plan.try(:id))

      plan.id
    end
  rescue
    nil
  end

  def update_stripe_subscription
    if plan_id_changed? && company.stripe_customer_id.present?
      StripeSubscription.for(self).update(company.users.count)
    end
  end
end
