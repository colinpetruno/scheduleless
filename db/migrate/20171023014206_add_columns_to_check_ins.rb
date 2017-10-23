class AddColumnsToCheckIns < ActiveRecord::Migration[5.0]
  def change
    add_column :check_ins, :location_id, :integer
    add_column :check_ins, :user_id, :integer
  end
end
