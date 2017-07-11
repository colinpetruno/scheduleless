class AddSizeToCompanies < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :size, :string
  end
end
