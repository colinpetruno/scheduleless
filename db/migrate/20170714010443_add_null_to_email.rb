class AddNullToEmail < ActiveRecord::Migration[5.0]
  def up
    change_column :users, :email, :string, null: true, default: nil
  end

  def down
    change_column :users, :email, :string, null: false
  end
end
