class PreferenceOptions
  def self.break_length
    [
      ["15 Minutes", 15], ["30 Minutes", 30],
      ["45 Minutes", 45], ["60 Minutes", 60],
    ]
  end

  def self.shift_overlap
    [
      ["No Overlap", 0],
      ["15 Minutes", 15],
      ["30 Minutes", 30],
      ["45 Minutes", 45],
      ["60 Minutes", 60],
    ]
  end

  def self.maximum_shift_length
    [
      ["4 Hours", 240], ["4 Hours 30 Minutes", 270],
      ["5 Hours", 300], ["5 Hours 30 Minutes", 330],
      ["6 Hours", 360], ["6 Hours 30 Minutes", 390],
      ["7 Hours", 420], ["7 Hours 30 Minutes", 450],
      ["8 Hours", 480], ["8 Hours 30 Minutes", 510],
      ["9 Hours", 540], ["9 Hours 30 Minutes", 570],
      ["10 Hours", 600], ["10 Hours 30 Minutes", 630],
      ["11 Hours", 660], ["11 Hours 30 Minutes", 690],
      ["12 Hours", 720], ["12 Hours 30 Minutes", 750],
      ["13 Hours", 780], ["13 Hours 30 Minutes", 810],
      ["14 Hours", 840],
    ]
  end

  def self.minimum_shift_length
    [
      ["2 Hours", 120], ["2 Hours 30 Minutes", 150], ["3 Hours", 180],
      ["3 Hours 30 Minutes", 210], ["4 Hours", 240],
      ["4 Hours 30 Minutes", 270], ["5 Hours", 300],
      ["5 Hours 30 Minutes", 330], ["6 Hours", 360],
      ["6 Hours 30 Minutes", 390], ["7 Hours", 420],
      ["7 Hours 30 Minutes", 450], ["8 Hours", 480],
    ]
  end

  def self.preferred_shift_length
    [
      ["2 Hours", 120], ["2 Hours 30 Minutes", 150],
      ["3 Hours", 180], ["3 Hours 30 Minutes", 210],
      ["4 Hours", 240], ["4 Hours 30 Minutes", 270],
      ["5 Hours", 300], ["5 Hours 30 Minutes", 330],
      ["6 Hours", 360], ["6 Hours 30 Minutes", 390],
      ["7 Hours", 420], ["7 Hours 30 Minutes", 450],
      ["8 Hours", 480], ["8 Hours 30 Minutes", 510],
      ["9 Hours", 540], ["8 Hours 30 Minutes", 570],
      ["10 Hours", 600]
    ]
  end

  def self.minimum_hours_for_break_options
    [
      ["1 hour", 1], ["2 hours", 2], ["3 hours", 3], ["4 hours", 4],
      ["5 hours", 5], ["6 hours", 6]
    ]
  end
end
