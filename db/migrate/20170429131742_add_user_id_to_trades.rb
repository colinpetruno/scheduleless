class AddUserIdToTrades < ActiveRecord::Migration[5.0]
  def change
    add_reference :trades, :user, index: true
  end
end
