class AddReferenceToShiftsOnInProgressShifts < ActiveRecord::Migration[5.0]
  def change
    add_reference :in_progress_shifts, :shift
  end
end
