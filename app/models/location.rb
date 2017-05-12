class Location < ApplicationRecord
  belongs_to :company
  has_many :popular_times, as: :popular
  has_many :shifts
  has_many :user_locations
  has_many :users, through: :user_locations

  has_one :preference, as: :preferable

  accepts_nested_attributes_for :preference

  update_index "site_search#location", :self

  def self.default_for(user)
    locations = user.locations

    locations.find_by(user_locations: { home: true }) || locations.first
  end

  def preference
    super || build_preference(
        company.
          preference.
          attributes.
          slice(
            "break_length",
            "minimum_shift_length",
            "maximum_shift_length",
            "shift_overlap"
          )
      )
  end
end
