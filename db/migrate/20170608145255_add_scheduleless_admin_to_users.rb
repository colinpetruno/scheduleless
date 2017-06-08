class AddSchedulelessAdminToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :scheduleless_admin, :boolean, default: false, null: false
  end
end
