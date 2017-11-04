class AddMoreUserColumns < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :manager_id, :integer
    add_column :users, :primary_location_id, :integer
  end
end
