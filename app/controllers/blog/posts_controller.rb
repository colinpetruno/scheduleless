module Blog
  class PostsController < BaseController
    def show
      @post = Blog::Post.find_by!(slug: params[:id])
    end
  end
end
