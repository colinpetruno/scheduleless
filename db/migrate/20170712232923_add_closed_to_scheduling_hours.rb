class AddClosedToSchedulingHours < ActiveRecord::Migration[5.0]
  def change
    add_column :scheduling_hours, :closed, :boolean, null: false, default: false
  end
end
