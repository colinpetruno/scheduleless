module Blog
  class CategoriesController < BaseController
    before_filter :ensure_valid_category

    def show
      @posts = Blog::Post.send(params[:id].to_sym)
    end

    private

    def ensure_valid_category
      if Blog::Post.categories.keys.exclude?(params[:id])
        raise ActiveRecord::RecordNotFound
      end
    end
  end
end
