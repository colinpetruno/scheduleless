class ShiftTransferer
  def initialize(new_user:, shift:)
    @new_user = new_user
    @shift = shift
  end

  def transfer
    Shift.create(new_shift_attributes)
  end

  private

  attr_reader :new_user, :old_user, :shift

  def new_shift_attributes
    shift.
      attributes.
      slice("company_id", "minute_start", "minute_end", "date", "location_id").
      merge({ user_id: new_user.id })
  end
end
