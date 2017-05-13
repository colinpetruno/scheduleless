class AddStateToOffers < ActiveRecord::Migration[5.0]
  def change
    add_column :offers, :state, :integer, null: false, default: 0
  end
end
