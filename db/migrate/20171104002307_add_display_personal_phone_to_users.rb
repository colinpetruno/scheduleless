class AddDisplayPersonalPhoneToUsers < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :personal_phone, :work_phone
    add_column :users, :display_phone, :boolean, default: true
  end
end
