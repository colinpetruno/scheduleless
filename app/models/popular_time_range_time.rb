class PopularTimeRangeTime < PopularTime
  validates :time_end, presence: true
  validates :time_start, presence: true
end
