class AddIndexToScheduleRules < ActiveRecord::Migration[5.0]
  def change
    add_index :schedule_rules, [:position_id, :period], unique: true
  end
end
