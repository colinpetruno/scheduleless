class Subscription < ApplicationRecord
  belongs_to :company
  belongs_to :credit_card
  belongs_to :plan

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
end
