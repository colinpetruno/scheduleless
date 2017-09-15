class AddDefaultToPricingPlans < ActiveRecord::Migration[5.0]
  def change
    add_column :plans, :default, :boolean, default: false
  end
end
