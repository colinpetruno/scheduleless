class DropPlanFromSubscription < ActiveRecord::Migration[5.0]
  def change
    remove_column :subscriptions, :plan
  end
end
