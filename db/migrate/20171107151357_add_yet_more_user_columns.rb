class AddYetMoreUserColumns < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :performs_exempt_duties, :boolean, default: false, null: false
    add_column :users, :exemption_status, :integer, default: 0, null: false
    add_column :users, :salary_amount_cents, :integer
    add_column :users, :employment_type, :integer, null: false, default: 0
  end
end
