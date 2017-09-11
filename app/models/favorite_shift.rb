class FavoriteShift < ApplicationRecord
  belongs_to :location
  belongs_to :position

  enum week_day: {
    sunday: 0,
    monday: 1,
    tuesday: 2,
    wednesday: 3,
    thursday: 4,
    friday: 5,
    saturday: 6,
    weekdays: 10,
    weekends: 20,
    any_day: 30
  }

  def self.week_day_options
    self.week_days.map do |key, value|
      [I18n.t("models.favorite_shift.weekday_options.#{key}"), key]
    end
  end
end
