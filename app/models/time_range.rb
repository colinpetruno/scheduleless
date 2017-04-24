class TimeRange
  DAY_OPTIONS = I18n.t("date.day_names").map.with_index(0).to_a

  def self.quarter_hour_options
    start_time = Time.new(2000, 1, 1, 0, 0, 0, "+00:00")
    end_time = Time.new(2000, 1, 1, 24, 0, 0, "+00:00")

    collection_times = []

    current_time = start_time

    while current_time <= end_time
      time_in_minutes = (current_time.hour * 60) + current_time.min

      collection_times.push([current_time.strftime("%l:%M %P"), time_in_minutes])

      current_time += 15.minutes
    end

    collection_times
  end
end
