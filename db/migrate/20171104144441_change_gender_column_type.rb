class ChangeGenderColumnType < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :legal_gender
    add_column :users, :legal_gender, :integer
  end
end
