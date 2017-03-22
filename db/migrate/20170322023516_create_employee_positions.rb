class CreateEmployeePositions < ActiveRecord::Migration[5.0]
  def change
    create_table :employee_positions do |t|
      t.references :user
      t.references :position
    end
  end
end
