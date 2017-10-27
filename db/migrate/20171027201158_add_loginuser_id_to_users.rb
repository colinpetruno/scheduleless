class AddLoginuserIdToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :login_user_id, :integer
    add_index :users, :login_user_id
  end
end
