class MakeLevelNotNull < ActiveRecord::Migration[5.0]
  def change
    change_column :popular_times, :level, :integer, null: false
    change_column :popular_times, :type, :string, null: false
  end
end
