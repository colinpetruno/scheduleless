class ScheduleRule < ApplicationRecord
  belongs_to :company
  belongs_to :position

  enum period: {
    open: 0,
    close: 1,
    all_day: 2
  }
end
