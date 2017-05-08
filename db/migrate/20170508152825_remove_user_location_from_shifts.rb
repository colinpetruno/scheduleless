class RemoveUserLocationFromShifts < ActiveRecord::Migration[5.0]
  def change
    remove_column :shifts, :user_location_id, :integer
  end
end
