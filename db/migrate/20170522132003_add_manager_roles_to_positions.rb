class AddManagerRolesToPositions < ActiveRecord::Migration[5.0]
  def change
    add_column :positions, :company_admin, :boolean, default: false, null: false
    add_column :positions, :location_admin, :boolean, default: false, null: false
  end
end
