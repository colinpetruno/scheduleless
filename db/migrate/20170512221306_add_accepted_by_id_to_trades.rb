class AddAcceptedByIdToTrades < ActiveRecord::Migration[5.0]
  def change
    add_column :trades, :traded_with_id, :integer
  end
end
