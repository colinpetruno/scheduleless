class AddDefaultToLocationCountry < ActiveRecord::Migration[5.0]
  def change
    change_column :locations, :country, :string, null: false, default: "US"
  end
end
