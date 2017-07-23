class AddPositionToShift < ActiveRecord::Migration[5.0]
  def change
    add_reference :shifts, :position, index: true
  end
end
