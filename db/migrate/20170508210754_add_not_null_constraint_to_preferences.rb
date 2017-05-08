class AddNotNullConstraintToPreferences < ActiveRecord::Migration[5.0]
  def change
    change_column :preferences, :preferable_id, :integer, null: false
  end
end
