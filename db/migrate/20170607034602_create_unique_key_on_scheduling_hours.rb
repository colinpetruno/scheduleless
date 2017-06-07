class CreateUniqueKeyOnSchedulingHours < ActiveRecord::Migration[5.0]
  def change
    add_index :scheduling_hours, [:location_id, :day], unique: true
  end
end
