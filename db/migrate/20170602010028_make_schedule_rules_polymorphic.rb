class MakeScheduleRulesPolymorphic < ActiveRecord::Migration[5.0]
  def change
    rename_column :schedule_rules, :company_id, :ruleable_id
    add_column :schedule_rules,
      :ruleable_type, :string, null: false, default: "Company"

    add_index :schedule_rules, [:ruleable_type, :ruleable_id]
  end
end
