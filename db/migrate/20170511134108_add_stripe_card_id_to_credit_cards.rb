class AddStripeCardIdToCreditCards < ActiveRecord::Migration[5.0]
  def change
    add_column :credit_cards, :stripe_card_id, :string
  end
end
