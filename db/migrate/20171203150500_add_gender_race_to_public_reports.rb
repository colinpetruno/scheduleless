class AddGenderRaceToPublicReports < ActiveRecord::Migration[5.0]
  def change
    add_column :public_reports, :company_name, :string
    add_column :public_reports, :public_company_id, :integer
    add_column :public_reports, :gender, :integer, null: false, default: 0
    add_column :public_reports, :race, :integer, null: false, default: 0
  end
end
