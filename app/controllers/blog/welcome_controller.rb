module Blog
  class WelcomeController < BaseController
    def index
      @posts = Blog::Post.all
    end
  end
end
