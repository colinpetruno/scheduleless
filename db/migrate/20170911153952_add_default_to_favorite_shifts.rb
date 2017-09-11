class AddDefaultToFavoriteShifts < ActiveRecord::Migration[5.0]
  def change
    change_column :favorite_shifts, :week_day, :integer, null: false, default: 30
  end
end
