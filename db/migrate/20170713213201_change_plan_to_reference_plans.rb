class ChangePlanToReferencePlans < ActiveRecord::Migration[5.0]
  def change
    add_reference :subscriptions, :plan
  end
end
