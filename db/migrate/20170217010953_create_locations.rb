class CreateLocations < ActiveRecord::Migration[5.0]
  def change
    create_table :locations do |t|
      t.string :line_1
      t.string :line_2
      t.string :line_3
      t.string :city
      t.string :county_province
      t.integer :postalcode
      t.string :country
      t.string :additional_details

      t.timestamps
    end
  end
end
