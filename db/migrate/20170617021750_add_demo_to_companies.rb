class AddDemoToCompanies < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :demo, :boolean, default: false, null: false
  end
end
