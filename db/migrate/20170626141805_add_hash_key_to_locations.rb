class AddHashKeyToLocations < ActiveRecord::Migration[5.0]
  def change
    add_column :locations, :hash_key, :string
  end
end
