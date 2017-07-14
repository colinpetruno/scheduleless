class PlanFeature < ApplicationRecord
  belongs_to :plan
  belongs_to :feature
end
