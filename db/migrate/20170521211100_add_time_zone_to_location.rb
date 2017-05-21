class AddTimeZoneToLocation < ActiveRecord::Migration[5.0]
  def change
    add_column :locations, :time_zone, :string, null: false, default: "Eastern Time (US & Canada)"
  end
end
