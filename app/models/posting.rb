class Posting < ApplicationRecord
  belongs_to :location
  belongs_to :user

  before_save :set_all_shifts_date_ranges

  def date_end=(date)
    if date.is_a? String
      formatted_date = Date.parse(date)
    else
      formatted_date = date
    end

    super(formatted_date.to_s(:integer))
  end

  def date_start=(date)
    if date.is_a? String
      formatted_date = Date.parse(date)
    else
      formatted_date = date
    end

    super(formatted_date.to_s(:integer))
  end

  private

  def set_all_shifts_date_ranges
    return true unless self.all_shifts

    last_shift = InProgressShift.
      unscoped.
      where(location_id: self.location_id).
      order(:date).
      last

    self.date_start = (Date.today - 1.day).to_s(:integer)
    self.date_end = last_shift.date
  end
end
