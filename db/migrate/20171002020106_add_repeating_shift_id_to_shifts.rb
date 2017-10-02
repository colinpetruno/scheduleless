class AddRepeatingShiftIdToShifts < ActiveRecord::Migration[5.0]
  def change
    add_column :shifts, :repeating_shift_id, :integer
  end
end
