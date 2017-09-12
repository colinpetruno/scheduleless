class AddRepeatingShiftReferenceToInProgressShifts < ActiveRecord::Migration[5.0]
  def change
    add_reference :in_progress_shifts, :repeating_shift
  end
end
