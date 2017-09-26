class AddScheduleStartToCompanies < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :schedule_start_day, :integer, null: false, default: 1
  end
end
