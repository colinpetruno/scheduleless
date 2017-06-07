class SchedulingHour < ApplicationRecord
  belongs_to :location

  def self.build_for(location)
    monday = 1
    sunday = 7

    location.
      scheduling_hours.
      build((monday..sunday).map { |day| {
        day: day,
        minute_open_end: 1020,
        minute_open_start: 480
      }})

    location.scheduling_hours
  end
end
