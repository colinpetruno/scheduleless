class ChangePublicCompaniesToIntegers < ActiveRecord::Migration[5.0]
  def change
    remove_column :public_companies, :company_size
    remove_column :public_companies, :revenue

    add_column :public_companies, :company_size, :integer, null: false, default: 0
    add_column :public_companies, :revenue, :integer, null: false, default: 0
  end
end
