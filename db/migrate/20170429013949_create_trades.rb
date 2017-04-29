class CreateTrades < ActiveRecord::Migration[5.0]
  def change
    create_table :trades do |t|
      t.references :shift
      t.references :location

      t.string :note, null: false
      t.boolean :accept_offers, default: true, null: false
      t.integer :accepted_shift_id
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
