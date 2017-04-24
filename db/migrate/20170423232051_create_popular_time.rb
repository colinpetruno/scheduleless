class CreatePopularTime < ActiveRecord::Migration[5.0]
  def change
    create_table :popular_times do |t|
      t.integer :day_start
      t.integer :day_end
      t.integer :time_start
      t.integer :time_end
      t.string :holiday_name
      t.integer :level
      t.string :type
      t.string :popular_type, null: false
      t.integer :popular_id, null: false

      t.timestamps
    end
  end
end
