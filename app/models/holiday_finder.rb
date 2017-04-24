class HolidayFinder
  def self.list
    Holidays.
      year_holidays([:us, :informal], Date.today.beginning_of_year).
      map { |obj| obj[:name] }
  end
end
