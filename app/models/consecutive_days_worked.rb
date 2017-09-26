class ConsecutiveDaysWorked
  # TODO: Good candidate for testing
  def self.for(shift)
    new(shift: shift).count
  end

  def initialize(shift:)
    @shift = shift
  end

  def count
    consecutive_days = 0

    reverse_dates.each_with_index do |date, index|
      if date_integers[index] == date
        consecutive_days += 1
      else
        break
      end
    end

    consecutive_days
  end

  private

  attr_reader :shift

  def date_integers
    @_date_integers ||= shifts.map(&:date).sort.reverse.uniq
  rescue
    []
  end

  def date_range
    end_date = Date.parse(shift.date.to_s)
    start_date = end_date - 7.days

    (start_date..end_date)
  end

  def date_integer_range
    (date_range.first.to_s(:integer).to_i..date_range.last.to_s(:integer).to_i)
  end

  def reverse_dates
    date_range.map { |date| date.to_s(:integer).to_i }.reverse
  end

  def shifts
    shift_class.where(user_id: shift.user_id, date: date_integer_range)
  end

  def shift_class
    shift.class
  end
end
