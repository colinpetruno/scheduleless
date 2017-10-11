class AddBasePayToPosition < ActiveRecord::Migration[5.0]
  def change
    add_column :positions, :base_pay, :integer, default: 0
  end
end
