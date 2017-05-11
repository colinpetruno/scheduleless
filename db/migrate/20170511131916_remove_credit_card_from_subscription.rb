class RemoveCreditCardFromSubscription < ActiveRecord::Migration[5.0]
  def change
    remove_column :subscriptions, :credit_card_id, :int
  end
end
