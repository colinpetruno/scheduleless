class AddMoreColumnsToCheckIn < ActiveRecord::Migration[5.0]
  def change
    add_column :check_ins, :check_in, :datetime
    add_column :check_ins, :check_out, :datetime
  end
end
