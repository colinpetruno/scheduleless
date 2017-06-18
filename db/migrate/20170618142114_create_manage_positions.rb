class CreateManagePositions < ActiveRecord::Migration[5.0]
  def change
    create_table :manage_positions do |t|
      t.references :position
      t.integer :manages_id, null: false
    end
  end
end
