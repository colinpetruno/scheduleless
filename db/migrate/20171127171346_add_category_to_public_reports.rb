class AddCategoryToPublicReports < ActiveRecord::Migration[5.0]
  def change
    add_column :public_reports, :category, :integer, null: false, default: 0
  end
end
