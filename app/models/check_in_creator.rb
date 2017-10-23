class CheckInCreator
  def self.for(shift)
    new(shift: shift)
  end

  def initialize(shift:)
    @shift = shift
  end

  def save
    check_in.save
  end

  def check_in
    # TODO: need to ensure that you can't check in to a shift thats already
    # checked into
    @check_in ||= shift.
      check_ins.
      create(check_in_date_time: DateTime.now.strftime("%Y%m%d%H%M%S"),
             check_in_date: DateAndTime::LocationTime.
               new(location: shift.location).
               current_date_integer,
             location_id: shift.location_id,
             check_in: DateTime.now,
             user_id: shift.user_id)
  end

  private

  attr_reader :shift
end
