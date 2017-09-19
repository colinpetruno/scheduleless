class AddTimesToRepeatingShift < ActiveRecord::Migration[5.0]
  def change
    add_column :repeating_shifts, :minute_start, :integer, null: false
    add_column :repeating_shifts, :minute_end, :integer, null: false
  end
end
