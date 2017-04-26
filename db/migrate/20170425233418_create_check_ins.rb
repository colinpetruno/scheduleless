class CreateCheckIns < ActiveRecord::Migration[5.0]
  def change
    create_table :check_ins do |t|
      t.references :shift
      t.integer :check_in_date_time, limit: 8
      t.integer :check_out_date_time, limit: 8

      t.timestamps
    end
  end
end
