class CreateFavoritesAndRecurringShifts < ActiveRecord::Migration[5.0]
  def change
    create_table :favorite_shifts do |t|
      t.references :location, null: false
      t.references :position, null: false
      t.integer :start_minute, null: false
      t.integer :end_minute, null: false
      t.integer :week_day

      t.timestamps
    end

    create_table :repeating_shifts do |t|
      t.references :user, null: false
      t.references :position, null: false
      t.integer :start_date, null: false
      t.integer :repeat_frequency, null: false, default: 7

      t.timestamps
    end
  end
end
