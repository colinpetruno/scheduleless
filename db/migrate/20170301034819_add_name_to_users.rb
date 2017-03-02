class AddNameToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :given_name, :string
    add_column :users, :family_name, :string
    add_column :users, :preferred_name, :string
  end
end
