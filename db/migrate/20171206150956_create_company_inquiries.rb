class CreateCompanyInquiries < ActiveRecord::Migration[5.0]
  def change
    create_table :company_inquiries do |t|
      t.string :company_name
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :job_title, null: false
      t.integer :employee_count, null: false, default: 0
      t.integer :public_company_id

      t.timestamps
    end
  end
end
