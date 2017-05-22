class AddDeletedAtToPositions < ActiveRecord::Migration[5.0]
  def change
    add_column :positions, :deleted_at, :datetime
  end
end
