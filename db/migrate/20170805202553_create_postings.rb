class CreatePostings < ActiveRecord::Migration[5.0]
  def change
    create_table :postings do |t|
      t.references :user, null: false
      t.references :location, null: false
      t.integer :date_start, null: false
      t.integer :date_end

      t.timestamps
    end
  end
end
