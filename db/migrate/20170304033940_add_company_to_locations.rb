class AddCompanyToLocations < ActiveRecord::Migration[5.0]
  def change
    add_reference :locations, :company, null: false
  end
end
