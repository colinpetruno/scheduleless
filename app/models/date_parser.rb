class DateParser
  def initialize(date:)
    @date = date
  end

  def day
    Date.parse(@date.to_s).strftime("%-d")
  end

  def month
    Date.parse(@date.to_s).strftime("%B")
  end

  def month_and_day
    Date.parse(@date.to_s).strftime("%B %-d")
  end
end
