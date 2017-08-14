class AddInProgressShiftIdToShifts < ActiveRecord::Migration[5.0]
  def change
    add_reference :shifts, :in_progress_shift
  end
end
