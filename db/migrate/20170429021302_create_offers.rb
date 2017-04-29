class CreateOffers < ActiveRecord::Migration[5.0]
  def change
    create_table :offers do |t|
      t.references :company
      t.references :trade

      t.string :note

      t.integer :offered_trade_id
      t.boolean :accepted

      t.timestamps
    end
  end
end
