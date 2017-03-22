class CreateScheduleRule < ActiveRecord::Migration[5.0]
  def change
    create_table :schedule_rules do |t|
      t.references :company, null: false
      t.references :position, null: false
      t.integer :period, null: false, default: 2
      t.integer :number_of_employees, null: false, default: 1
    end
  end
end
