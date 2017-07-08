class CreateBlogPosts < ActiveRecord::Migration[5.0]
  def change
    create_table :blog_posts do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.string :preview_description
      t.text :body, null: false
      t.integer :category, null: false, default: 0
      t.integer :created_by_id, null: false

      t.boolean :published, null: false, default: false
      t.datetime :published_at
      t.integer :view_count, null: false, default: 0

      t.timestamps
    end

    add_index :blog_posts, :slug
  end
end
