class ModifyPreferredHoursTable < ActiveRecord::Migration[5.0]
  def change
    remove_column :preferred_hours, :start
    remove_column :preferred_hours, :end
    remove_column :preferred_hours, :open
    remove_column :preferred_hours, :close

    add_column :preferred_hours, :start, :integer, default: 0, null: false
    add_column :preferred_hours, :end, :integer, default: 1440, null: false
  end
end
