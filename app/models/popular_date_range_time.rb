class PopularDateRangeTime < PopularTime
  attr_accessor :day_end_day, :day_end_month, :day_start_day, :day_start_month

  before_validation :set_dates

  validates :day_end, presence: true
  validates :day_start, presence: true

  private

  def set_dates
    if day_end_day.present? && day_start_day.present?
      self.day_end = "#{sprintf('%02d', day_end_month.to_i)}#{sprintf('%02d', day_end_day.to_i)}".to_i
      self.day_start = "#{sprintf('%02d', day_start_month.to_i)}#{sprintf('%02d', day_start_day.to_i)}".to_i
    end
  end

end
