class ChangeCategoryColumnOnPublicCompanies < ActiveRecord::Migration[5.0]
  def change
    remove_column :public_companies, :category
    add_column :public_companies, :category, :integer, null: false, default: 0
  end
end
