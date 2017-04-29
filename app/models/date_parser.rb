class DateParser
  def initialize(date:)
    @date = date
  end

  def month_and_day
    Date.parse(@date.to_s).strftime("%B %-d")
  end
end
