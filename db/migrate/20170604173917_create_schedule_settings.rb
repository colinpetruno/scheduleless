class CreateScheduleSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :schedule_settings do |t|
      t.references :company
      t.integer :schedule_duration, null: false, default: 2
      t.integer :day_start, null: false, default: 1
      t.integer :lead_time, null: false, default: 2

      t.timestamps
    end
  end
end
