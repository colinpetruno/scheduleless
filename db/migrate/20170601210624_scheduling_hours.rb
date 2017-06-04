class SchedulingHours < ActiveRecord::Migration[5.0]
  def change
    create_table :scheduling_hours do |t|
      t.references :location
      t.integer :day, null: false
      t.integer :minute_open_start, null: false
      t.integer :minute_open_end, null: false
      t.integer :minute_schedulable_start
      t.integer :minute_schedulable_end

      t.timestamps
    end
  end
end
