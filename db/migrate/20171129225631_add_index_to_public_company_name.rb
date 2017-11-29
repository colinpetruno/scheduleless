class AddIndexToPublicCompanyName < ActiveRecord::Migration[5.0]
  def change
    add_index :public_companies, :name
  end
end
