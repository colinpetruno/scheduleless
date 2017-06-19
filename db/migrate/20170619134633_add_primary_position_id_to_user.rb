class AddPrimaryPositionIdToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :primary_position_id, :integer
  end
end
