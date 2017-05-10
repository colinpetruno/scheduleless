class AddDefaultToCreditCards < ActiveRecord::Migration[5.0]
  def change
    add_column :credit_cards, :default, :boolean, null: false, default: false
  end
end
