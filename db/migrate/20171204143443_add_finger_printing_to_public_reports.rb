class AddFingerPrintingToPublicReports < ActiveRecord::Migration[5.0]
  def change
    add_column :public_reports, :ip_address, :string
    add_column :public_reports, :remote_ip_address, :string
    add_column :public_reports, :user_agent, :string
  end
end
