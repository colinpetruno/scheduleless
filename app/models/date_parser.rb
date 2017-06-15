class DateParser
  def initialize(date:)
    @date = date
  end

  def day
    parsed_date.strftime("%-d")
  end

  def month
    parsed_date.strftime("%B")
  end

  def month_number
    parsed_date.strftime("%m")
  end

  def month_and_day
    parsed_date.strftime("%B %-d")
  end

  private

  def parsed_date
    Date.parse(@date.to_s)
  end
end
