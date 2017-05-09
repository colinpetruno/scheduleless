class Subscription < ApplicationRecord
  belongs_to :company
  belongs_to :credit_card

  enum plan: {
    small: 0,
    medium: 1
  }

  def self.collection_labels
    self.plans.keys.map do |key|
      [I18n.t("models.subscription.#{key}"), key]
    end
  end
end
