class BlogsController < AuthenticatedController
	
	def index
		@blogs = Blog.paginate(page: params[:page], per_page: 10)
	end

	def show
		@blog = Blog.find(params[:id])
		@blog_posts = @blog.blog_posts.paginate(page: params[:page], :per_page => 10)
	end
end