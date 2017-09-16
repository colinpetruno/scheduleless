class AddSalaryToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :salary, :boolean, default: false, null: false
  end
end
