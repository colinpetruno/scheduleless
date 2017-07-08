module Blog
  module Admin
    class BlogPostsController < BaseController
      def create
        @post = Post.new(blog_post_params)

        if @post.save
          redirect_to blog_admin_root_path
        else
          render :new
        end
      end

      def edit
        @post = Post.find_by!(slug: params[:id])
      end

      def index
        @post = Post.all
      end

      def new
        @post = Post.new
      end

      def update
        @post = Post.find_by!(slug: params[:id])

        if @post.update(blog_post_params)
          redirect_to blog_admin_root_path
        else
          render :edit
        end
      end

      private

      def blog_post_params
        params.
          require(:blog_post).
          permit(
            :body,
            :category,
            :preview_description,
            :published,
            :slug,
            :title
          ).merge(
            created_by_id: current_user.id
          )
      end
    end
  end
end
