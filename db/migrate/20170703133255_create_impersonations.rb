class CreateImpersonations < ActiveRecord::Migration[5.0]
  def change
    create_table :impersonations do |t|
      t.integer :user_id, null: false
      t.integer :impersonated_user_id, null: false

      t.timestamps
    end
  end
end
