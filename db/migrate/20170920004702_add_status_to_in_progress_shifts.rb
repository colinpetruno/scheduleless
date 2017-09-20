class AddStatusToInProgressShifts < ActiveRecord::Migration[5.0]
  def change
    add_column :in_progress_shifts, :state, :integer, null: false, default: 0
    add_column :in_progress_shifts, :deleted_at, :datetime

    add_column :shifts, :deleted_at, :datetime
  end
end
