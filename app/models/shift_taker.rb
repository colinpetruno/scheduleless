class ShiftTaker
  def initialize(trade:, user:)
    @trade = trade
    @user = user
  end

  def take
    if permitted?
      original_shift.update(state: Shift.states[:taken])
      trade.update(status: Trade.statuses[:completed])

      @new_shift = ShiftTransferer.
        new(new_user: user, shift: original_shift).
        transfer
    else
      # TODO: Some error things go here
      false
    end
  end

  private

  attr_reader :new_shift, :trade, :user

  def original_shift
    trade.shift
  end

  def permitted?
    # AvailabilityChecker.
    #  new(date: original_shift.date,
    #     minutes_to_add: original_shift.length_in_minutes,
    #    user: user).
    #  can_work?

    # todo rewrite
    true
  end
end
