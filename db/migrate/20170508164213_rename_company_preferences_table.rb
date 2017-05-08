class RenameCompanyPreferencesTable < ActiveRecord::Migration[5.0]
  def change
    rename_table :company_preferences, :preferences
    add_column :preferences, :preferable_type, :string, null: false, default: "Company"
    rename_column :preferences, :company_id, :preferable_id
  end
end
