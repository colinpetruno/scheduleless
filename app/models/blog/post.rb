module Blog
  def self.table_name_prefix
    "blog_"
  end

  class Post < ApplicationRecord
    belongs_to :creator, class_name: "User", foreign_key: "created_by_id"

    enum category: {
      product_announcements: 0,
      scheduling: 1,
      tutorials: 2
    }

    def to_param
      slug
    end
  end
end
