class UpdateIndexForScheduleRules < ActiveRecord::Migration[5.0]
  def change
    remove_index :schedule_rules, [:position_id, :period]

    add_index :schedule_rules,
      [:ruleable_type, :ruleable_id, :position_id, :period],
      name: "unique_by_type_and_ids",
      unique: true
  end
end
