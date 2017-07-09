module Blog
  class WelcomeController < BaseController
    def index
      @posts = Blog::Post.where(published: true).order(published_at: :desc)
    end
  end
end
