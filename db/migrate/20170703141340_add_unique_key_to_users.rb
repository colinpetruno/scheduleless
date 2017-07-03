class AddUniqueKeyToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :hash_key, :string
  end
end
