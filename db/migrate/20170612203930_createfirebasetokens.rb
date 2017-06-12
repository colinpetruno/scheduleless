class Createfirebasetokens < ActiveRecord::Migration[5.0]
  def change
    create_table :firebase_tokens do |t|
      t.references :user
      t.string :token, null: false
      t.boolean :active, null: false, default: true
      t.timestamps
    end
  end
end
