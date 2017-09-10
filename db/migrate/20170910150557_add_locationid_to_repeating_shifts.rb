class AddLocationidToRepeatingShifts < ActiveRecord::Migration[5.0]
  def change
    add_reference :repeating_shifts, :location, null: false
  end
end
