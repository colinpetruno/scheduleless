class DropRepeatingShiftConstraints < ActiveRecord::Migration[5.0]
  def change
    change_column :repeating_shifts, :position_id, :integer, null: true
    change_column :repeating_shifts, :user_id, :integer, null: true
  end
end
