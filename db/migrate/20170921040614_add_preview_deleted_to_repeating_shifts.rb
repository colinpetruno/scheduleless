class AddPreviewDeletedToRepeatingShifts < ActiveRecord::Migration[5.0]
  def change
    add_column :repeating_shifts, :preview_deleted_at, :datetime
  end
end
