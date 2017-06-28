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

  def self.minimum_shift_length_options
    [
      ["2 hours", 120], ["3 hours", 180], ["4 hours", 240], ["5 hours", 300],
      ["6 hours", 360], ["7 hours", 420], ["8 hours", 480]
    ]
  end

  def self.preferred_shift_length_options
    [
      ["2 hours", 120], ["3 hours", 180], ["4 hours", 240], ["5 hours", 300],
      ["6 hours", 360], ["7 hours", 420], ["8 hours", 480], ["9 hours", 540],
      ["10 hours", 600], ["11 hours", 660], ["12 hours", 720]
    ]
  end

  def self.maximum_shift_length_options
    [
      ["4 hours", 240], ["5 hours", 300], ["6 hours", 360], ["7 hours", 420],
      ["8 hours", 480], ["9 hours", 540], ["10 hours", 600], ["11 hours", 660],
      ["12 hours", 720], ["13 hours", 780], ["14 hours", 840]
    ]
  end

  def self.break_length_options
    [
      ["15 minutes", 15], ["30 minutes", 30], ["45 minutes", 45],
      ["1 hour", 60]
    ]
  end

  def self.shift_overlap_options
    [
      ["0 minutes", 0], ["15 minutes", 15], ["30 minutes", 30],
      ["45 minutes", 45], ["1 hour", 60]
    ]
  end

  def self.minimum_hours_for_break_options
    [
      ["1 hour", 1], ["2 hours", 2], ["3 hours", 3], ["4 hours", 4],
      ["5 hours", 5], ["6 hours", 6]
    ]
  end
end
