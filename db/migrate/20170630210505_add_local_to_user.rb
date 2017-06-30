class AddLocalToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :locale, :string, default: "en", null: false
  end
end
