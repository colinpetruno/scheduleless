class AddUserIdAndLocationIdToShifts < ActiveRecord::Migration[5.0]
  def change
    add_reference :shifts, :location, index: true, null: false
    add_reference :shifts, :user, index: true, null: false

    add_foreign_key :shifts, :locations
    add_foreign_key :shifts, :users
  end
end
