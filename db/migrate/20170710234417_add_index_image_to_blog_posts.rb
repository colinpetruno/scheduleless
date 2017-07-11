class AddIndexImageToBlogPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :blog_posts, :index_image, :string
  end
end
