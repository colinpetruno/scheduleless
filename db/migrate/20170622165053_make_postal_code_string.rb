class MakePostalCodeString < ActiveRecord::Migration[5.0]
  def change
    change_column :locations, :postalcode, :string
  end
end
