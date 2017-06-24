class AddDaysToScheduleRules < ActiveRecord::Migration[5.0]
  def change
    remove_index :schedule_rules, name: "unique_by_type_and_ids"
    add_column :schedule_rules, :day, :integer
    add_index :schedule_rules, [:position_id, :period, :day], unique: true
  end
end
