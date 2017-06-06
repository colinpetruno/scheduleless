class CreateInProgressShifts < ActiveRecord::Migration[5.0]
  def change
    create_table :in_progress_shifts do |t|
      t.references :company
      t.integer :minute_start, null: false
      t.integer :minute_end, null: false
      t.integer :date, null: false

      t.timestamps

      t.references :location
      t.references :user
      t.references :scheduling_period
    end
  end
end
