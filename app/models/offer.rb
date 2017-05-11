class Offer < ApplicationRecord
  belongs_to :company
  belongs_to :trade
  belongs_to :user
end
