class RemoveForeignKeyOnTokens < ActiveRecord::Migration[5.0]
  def change
    remove_foreign_key :oauth_access_tokens, :users
  end
end
