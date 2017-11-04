class YetMoreuserColumns < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :employee_status, :integer, default: 0, null: false
    add_column :users, :start_date, :integer
  end
end
