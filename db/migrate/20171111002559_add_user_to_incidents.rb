class AddUserToIncidents < ActiveRecord::Migration[5.0]
  def change
    add_reference :incidents, :user, null: false
  end
end
