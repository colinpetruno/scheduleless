class AddNotNullToCompany < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :company_id, :integer, null: false
  end
end
