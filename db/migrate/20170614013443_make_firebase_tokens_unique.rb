class MakeFirebaseTokensUnique < ActiveRecord::Migration[5.0]
  def change
    add_index :firebase_tokens, :token, unique: true
  end
end
