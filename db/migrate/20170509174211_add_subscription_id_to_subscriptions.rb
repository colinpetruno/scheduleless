class AddSubscriptionIdToSubscriptions < ActiveRecord::Migration[5.0]
  def change
    add_column :subscriptions, :stripe_subscription_id, :string
  end
end
