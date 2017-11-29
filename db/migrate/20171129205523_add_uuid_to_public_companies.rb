class AddUuidToPublicCompanies < ActiveRecord::Migration[5.0]
  def change
    add_column :public_companies, :uuid, :string
  end
end
