class AddNotNullToTrades < ActiveRecord::Migration[5.0]
  def change
    change_column :trades, :shift_id, :integer, null: false
  end
end
