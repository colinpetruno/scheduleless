class CheckOut
  attr_reader :shift

  def self.for(shift)
    new(shift: shift)
  end

  def initialize(shift:)
    @shift = shift
  end

  def check_out
    check_in.update(check_out_date_time: DateTime.now.strftime("%Y%m%d%H%M%S"))
  end

  def errors
    check_in.errors
  end

  def check_in
    @_check_in ||= shift.check_ins.find_by(check_out_date_time: nil)
  end
end
