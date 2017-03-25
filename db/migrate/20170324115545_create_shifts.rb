class CreateShifts < ActiveRecord::Migration[5.0]
  def change
    create_table :shifts do |t|
      t.integer :user_id
      t.integer :company_id
      t.integer :minute_start
      t.integer :minute_end
      t.integer :date

      t.timestamps
    end
  end
end
