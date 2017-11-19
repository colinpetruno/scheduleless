class AddPublicCompanies < ActiveRecord::Migration[5.0]
  def change
    create_table :public_companies do |t|
      t.string :name, null: false, unique: true
      t.string :website, unique: true
      t.string :company_type
      t.string :headquarters
      t.string :category

      t.string :revenue
      t.string :company_size
      t.integer :founded

      t.string :linkedin_url
      t.string :twitter_url
      t.string :facebook_url
      t.string :instagram_url
      t.string :youtube_url

      t.string :gd_logo_url
      t.string :gd_url
      t.integer :gd_employer_id
      t.integer :gd_id


      t.timestamps
    end
  end
end
