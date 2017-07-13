class TimeRange
  DAY_OPTIONS = I18n.t("date.day_names").map.with_index(0).to_a

  def self.half_hour_options
    start_time = Time.new(2000, 1, 1, 0, 0, 0, "+00:00")
    end_time = Time.new(2000, 1, 1, 24, 0, 0, "+00:00")

    collection_times = []
    current_time = start_time

    while current_time <= end_time
      time_in_minutes = (current_time.hour * 60) + current_time.min

      collection_times.push([current_time.strftime("%l:%M %P"), time_in_minutes])

      current_time += 30.minutes
    end

    collection_times
  end

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

  def self.year_options
    [Time.current.year, Time.current.year+1]
  end

  def self.month_options
    [
      ["January", "01"], ["February", "02"], ["March", "03"], ["April", "04"],
      ["May", "05"], ["June", "06"], ["July", "07"], ["August", "08"],
      ["September", "09"], ["October", "10"], ["November", "11"],
      ["December", "12"]
    ]
  end

  def self.date_options
    (0..31).map do |n|
      n.to_s
    end
  end
end
