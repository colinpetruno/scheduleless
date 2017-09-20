class ShiftPublisher
  def self.from(posting)
    new(end_date: posting.date_end,
        start_date: posting.date_start,
        location: posting.location).
    publish
  end

  def initialize(end_date: Date.today, location:, start_date: Date.today)
    @end_date = end_date.is_a?(String) ? Date.parse(end_date.to_s) : end_date
    @location = location
    @start_date = start_date.is_a?(String) ? Date.parse(start_date.to_s) : start_date
  end

  def publish
    ActiveRecord::Base.transaction do
      shifts_to_publish.map do |in_progress_shift|
        Shifts::Publishers::SingleShift.
          new(in_progress_shift: in_progress_shift,
              notify: false).
          publish
      end
    end
  end

  private

  attr_reader :end_date, :location, :start_date

  def date_range
    (start_date.to_s(:integer).to_i..end_date.to_s(:integer).to_i)
  end

  def shift_params(in_progress_shift)
    in_progress_shift.
      slice(:minute_start,
            :minute_end,
            :date,
            :location_id,
            :user_id).
      merge(in_progress_shift_id: in_progress_shift.id)
  end

  def shifts_to_publish
    InProgressShift.where(date: date_range, location_id: location.id)
  end
end
