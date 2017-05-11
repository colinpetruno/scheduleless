class AddUserIdToOffer < ActiveRecord::Migration[5.0]
  def change
    add_reference :offers, :user, null: false
  end
end
