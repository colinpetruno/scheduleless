class AddFieldsToPreferences < ActiveRecord::Migration[5.0]
  def change
    add_column :preferences, :paid_break, :boolean, null: false, default: false
    add_column :preferences, :minimum_hours_for_break, :integer, null: false, default: 4
  end
end
