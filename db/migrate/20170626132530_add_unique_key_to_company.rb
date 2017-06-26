class AddUniqueKeyToCompany < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :hash_key, :string
  end
end
