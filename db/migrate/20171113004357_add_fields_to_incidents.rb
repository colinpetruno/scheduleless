class AddFieldsToIncidents < ActiveRecord::Migration[5.0]
  def change
    add_column :incidents, :occured_on, :date
    add_column :incidents, :category, :integer, null: false, default: 0
    add_column :incidents, :summary, :string
  end
end
