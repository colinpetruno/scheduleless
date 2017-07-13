module Blog
  def self.table_name_prefix
    "blog_"
  end

  class Post < ApplicationRecord
    validates_length_of :body, minimum: 100, allow_blank: false
    validates_length_of :slug, minimum: 5, allow_blank: false
    validates_length_of :title, minimum: 5, maximum: 255, allow_blank: false
    validates_length_of :preview_description, minimum: 5, maximum: 255, allow_blank: false

    belongs_to :creator, class_name: "User", foreign_key: "created_by_id"

    before_save :set_published_at

    mount_uploader :index_image, BlogIndexImageUploader

    enum category: {
      product_announcements: 0,
      scheduling: 1,
      tutorials: 2,
      business_tips: 3
    }

    def self.collection_labels
      self.categories.keys.map do |key|
        [I18n.t("models.blog_post.category.#{key}") ,key]
      end
    end

    def to_param
      slug
    end

    private

    def set_published_at
      if published? && published_at.blank?
        self.published_at = DateTime.now
      end
    end
  end
end
