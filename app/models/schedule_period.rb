class SchedulePeriod
  # TODO: Good Testing Candidate
  def self.for(company)
    new(company: company)
  end

  def initialize(company:, date: Date.today)
    @company = company
    @date = date
  end

  def day_of(date_num)
    wday = date_num.is_a?(Date) ? date_num.wday : Date.parse(date_num.to_s).wday

    (0..6).to_a.rotate(first_day).index(wday) + 1
  end

  def start_date
    date - (day_of(date) - 1).days
  end

  def end_date
    start_date + 6.days
  end

  def date_range
    (start_date..end_date)
  end

  def date_range_integers
    (start_date.to_s(:integer).to_i..end_date.to_s(:integer).to_i)
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

  attr_reader :company, :date

  def day_array
    @_day_array ||= (0..6).to_a
  end
end
