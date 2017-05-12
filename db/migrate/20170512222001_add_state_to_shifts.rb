class AddStateToShifts < ActiveRecord::Migration[5.0]
  def change
    add_column :shifts, :state, :integer, null: false, default: 0
  end
end
