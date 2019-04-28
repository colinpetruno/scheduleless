class AddPriceToPlans < ActiveRecord::Migration[6.0]
  def change
    add_column :plans, :price, :integer, null: false, default: 0
  end
end
