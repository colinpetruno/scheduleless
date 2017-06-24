class AddPreferredShiftLengthToPreferences < ActiveRecord::Migration[5.0]
  def change
    add_column :preferences, :preferred_shift_length, :integer, default: 360, null: false
  end
end
