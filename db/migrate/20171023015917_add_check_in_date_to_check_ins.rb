class AddCheckInDateToCheckIns < ActiveRecord::Migration[5.0]
  def change
    add_column :check_ins, :check_in_date, :integer
  end
end
