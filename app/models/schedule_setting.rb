class ScheduleSetting < ApplicationRecord
  belongs_to :company

  attr_accessor :start_date

  def self.duration_options
    [["1 week", 1], ["2 weeks", 2], ["3 weeks", 3], ["4 weeks", 4]]
  end

  def self.lead_time_options
    [["1 period", 1], ["2 periods", 2], ["3 periods", 3]]
  end

  def self.start_date_options
    start_date = Date.today + 1.week

    (1..21).map do |offset|
      date = Date.today + offset.days

      [date.to_s(:full_day_and_month), date.to_s(:day_integer)]
    end
  end

  def start_day_of_week
    Date::DAYNAMES[day_start]
  end
end
