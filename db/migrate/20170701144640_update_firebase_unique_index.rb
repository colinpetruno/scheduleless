class UpdateFirebaseUniqueIndex < ActiveRecord::Migration[5.0]
  def change
    add_index :firebase_tokens, [:user_id, :token], unique: true
    remove_index :firebase_tokens, :token
  end
end
