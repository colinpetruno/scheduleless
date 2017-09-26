class SchedulePeriod
  # TODO: Good Testing Candidate
  def self.for(company)
    new(company: company)
  end

  def initialize(company:)
    @company = company
  end

  def day_of(date)
    wday = date.is_a?(Date) ? date.wday : Date.parse(date.to_s).wday

    (0..6).to_a.rotate(first_day).index(wday) + 1
  end

  def first_day
    company.schedule_start_day
  end

  def sixth_day
    day_array[first_day-2]
  end

  def seventh_day
    day_array[first_day-1]
  end

  private

  attr_reader :company

  def day_array
    @_day_array ||= (0..6).to_a
  end
end
