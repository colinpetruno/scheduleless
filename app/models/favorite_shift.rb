class FavoriteShift < ApplicationRecord
  belongs_to :location
  belongs_to :position
end
