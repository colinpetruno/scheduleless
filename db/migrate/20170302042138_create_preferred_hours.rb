class CreatePreferredHours < ActiveRecord::Migration[5.0]
  def change
    create_table :preferred_hours do |t|
      t.references :user

      t.integer :day
      t.time :start
      t.time :end
      t.boolean :open, default: true
      t.boolean :close, default: true
    end

    add_index :preferred_hours, [:user_id, :day], :unique => true
  end
end
