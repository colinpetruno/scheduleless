class Plan < ApplicationRecord
  belongs_to :subscription
  has_many :plan_features
  has_many :features, through: :plan_features

  before_validation :check_default

  private

  def check_default
    if self.default?
      Plan.where(default: true).update_all(default: false)
    elsif Plan.where(default: true).where.not(id: self.id).blank?
      errors.add(:default, "A default plan must be present")
    end
  end
end
