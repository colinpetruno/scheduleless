class AddShiftIdToInProgressShifts < ActiveRecord::Migration[5.0]
  def change
    add_column :in_progress_shifts, :position_id, :integer
  end
end
