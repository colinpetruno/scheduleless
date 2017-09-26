class DropScheduleSettings < ActiveRecord::Migration[5.0]
  def change
    drop_table :schedule_settings
  end
end
