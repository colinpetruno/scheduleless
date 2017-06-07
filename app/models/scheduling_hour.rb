class SchedulingHour < ApplicationRecord
  belongs_to :location

  def self.build_for(location)
    sunday = 0
    saturday = 6

    location.
      scheduling_hours.
      build((sunday..saturday).map { |day| {
        day: day,
        minute_open_end: 1020,
        minute_open_start: 480
      }})

    location.scheduling_hours
  end

  def minute_schedulable_end
    super || minute_open_end
  end

  def minute_schedulable_start
    super || minute_open_start
  end
end
