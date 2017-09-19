class AddPublishedToRepeatingShifts < ActiveRecord::Migration[5.0]
  def change
    add_column :repeating_shifts, :published, :boolean, null: false, default: false
  end
end
