class AddPayByTypeToCompany < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :pay_by_type, :integer, null: false, default: 0
  end
end
