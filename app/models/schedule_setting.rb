class ScheduleSetting < ApplicationRecord
  belongs_to :company

  def start_day_of_week
    Date::DAYNAMES[day_start]
  end
end
