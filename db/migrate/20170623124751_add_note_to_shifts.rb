class AddNoteToShifts < ActiveRecord::Migration[5.0]
  def change
    add_column :shifts, :note, :string
  end
end
