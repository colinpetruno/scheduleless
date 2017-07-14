class Plan < ApplicationRecord
  belongs_to :subscription
  has_many :plan_features
  has_many :features, through: :plan_features
end
