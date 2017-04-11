class AddAdminToLocations < ActiveRecord::Migration[5.0]
  def change
    add_column :user_locations, :admin, :boolean, default: false, null: false
  end
end
