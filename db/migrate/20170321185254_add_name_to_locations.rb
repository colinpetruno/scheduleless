class AddNameToLocations < ActiveRecord::Migration[5.0]
  def change
    add_column :locations, :name, :string
  end
end
