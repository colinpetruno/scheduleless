class CreateShifts < ActiveRecord::Migration[5.0]
  def change
    create_table :shifts do |t|
      t.references :user_location
      t.references :company
      t.integer :minute_start, null: false
      t.integer :minute_end, null: false
      t.integer :date, null: false

      t.timestamps
    end
  end
end
