class AddPrimaryToEmployeePositions < ActiveRecord::Migration[5.0]
  def change
    add_column :employee_positions, :primary, :boolean, null: false, default: false
  end
end
