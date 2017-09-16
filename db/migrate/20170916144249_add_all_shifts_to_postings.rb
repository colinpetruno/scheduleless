class AddAllShiftsToPostings < ActiveRecord::Migration[5.0]
  def change
    add_column :postings, :all_shifts, :boolean, default: true, null: false
  end
end
