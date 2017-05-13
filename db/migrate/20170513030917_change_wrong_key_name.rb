class ChangeWrongKeyName < ActiveRecord::Migration[5.0]
  def change
    rename_column :offers, :offered_trade_id, :offered_shift_id
  end
end
