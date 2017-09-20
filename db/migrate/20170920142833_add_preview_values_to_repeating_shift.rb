class AddPreviewValuesToRepeatingShift < ActiveRecord::Migration[5.0]
  def change
    add_column :repeating_shifts, :preview_user_id, :integer
    add_column :repeating_shifts, :preview_position_id, :integer
    add_column :repeating_shifts, :preview_start_date, :integer
    add_column :repeating_shifts, :preview_repeat_frequency, :integer
    add_column :repeating_shifts, :preview_location_id, :integer
    add_column :repeating_shifts, :preview_minute_end, :integer
    add_column :repeating_shifts, :preview_minute_start, :integer

    add_column :repeating_shifts, :deleted_at, :datetime
  end
end
