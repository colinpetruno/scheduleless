class AddMinShiftLengthToCompanyPreferences < ActiveRecord::Migration[5.0]
  def change
    add_column :company_preferences, :minimum_shift_length, :integer, default: 240, null: false
    add_column :company_preferences, :maximum_shift_length, :integer, default: 480, null: false
    add_column :company_preferences, :break_length, :integer, default: 60, null: false
  end
end
