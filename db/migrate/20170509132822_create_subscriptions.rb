class CreateSubscriptions < ActiveRecord::Migration[5.0]
  def change
    create_table :credit_cards do |t|
      t.references :company
      t.integer :exp_month, null: false
      t.integer :exp_year, null: false
      t.integer :last_4, null: false
      t.string :brand, null: false
      t.string :token, null: false

      t.timestamps
    end

    create_table :subscriptions do |t|
      t.references :company
      t.references :credit_card

      t.integer :plan, null: false, default: 1

      t.timestamps
    end
  end
end
