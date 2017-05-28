class PopularDateRangeTime < PopularTime
  attr_writer :day_end_day, :day_end_month, :day_start_day, :day_start_month

  before_validation :set_dates

  validates :day_end, presence: true
  validates :day_start, presence: true

  def from_string
    string = day_start.to_s.rjust(4, "0")
    day = string.last(2).to_i
    month = string.first(2).to_i

    "#{I18n.t("date.month_names")[month]} #{day.ordinalize}"
  end

  def to_string
    string = day_end.to_s.rjust(4, "0")
    day = string.last(2).to_i
    month = string.first(2).to_i

    "#{I18n.t("date.month_names")[month]} #{day.ordinalize}"
  end

  def day_end_day
    @day_end_day || day_end.to_s.rjust(4, "0").last(2).to_i
  end

  def day_end_month
    @day_end_month || day_end.to_s.rjust(4, "0").first(2).to_i
  end

  def day_start_day
    @day_start_day || day_start.to_s.rjust(4, "0").last(2).to_i
  end

  def day_start_month
    @day_start_month || day_start.to_s.rjust(4, "0").first(2).to_i
  end


  private

  def set_dates
    if day_end_day.present? && day_start_day.present?
      self.day_end = "#{sprintf('%02d', day_end_month.to_i)}#{sprintf('%02d', day_end_day.to_i)}".to_i
      self.day_start = "#{sprintf('%02d', day_start_month.to_i)}#{sprintf('%02d', day_start_day.to_i)}".to_i
    end
  end

end
