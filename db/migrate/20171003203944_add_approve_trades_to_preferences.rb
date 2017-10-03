class AddApproveTradesToPreferences < ActiveRecord::Migration[5.0]
  def change
    add_column :preferences, :approve_trades, :boolean, default: true, null: false
  end
end
