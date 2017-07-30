class AddEditedToInProgressShifts < ActiveRecord::Migration[5.0]
  def change
    add_column :in_progress_shifts, :edited, :boolean, null: false, default: true
  end
end
