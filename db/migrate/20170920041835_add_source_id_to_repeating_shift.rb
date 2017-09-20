class AddSourceIdToRepeatingShift < ActiveRecord::Migration[5.0]
  def change
    add_column :repeating_shifts, :in_progress_shift_id, :integer
  end
end
