class CreateSchedulingPeriods < ActiveRecord::Migration[5.0]
  def change
    create_table :scheduling_periods do |t|
      t.references :company
      t.references :location

      t.integer :start_date, null: false
      t.integer :end_date, null: false

      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
