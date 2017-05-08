class Preference < ApplicationRecord
  belongs_to :preferable, polymorphic: true
end
