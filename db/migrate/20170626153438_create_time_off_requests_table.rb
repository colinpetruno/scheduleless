class CreateTimeOffRequestsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :time_off_requests do |t|
      t.references :user
      t.integer :start_date
      t.integer :start_minutes
      t.integer :end_minutes
      t.integer :end_date
      t.integer :status, null: false, default: 0
      t.integer :reviewed_by

      t.timestamps
    end
  end
end
