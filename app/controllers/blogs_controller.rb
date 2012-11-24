class BlogsController < AuthenticatedController
	skip_before_filter :signed_in_user, only: [:index, :show]
	
	def index
		@blogs = Blog.paginate(page: params[:page], :per_page => 10)
	end

	def show
		@blog = Blog.find(params[:id])
		if signed_in?
			@blog_posts = BlogPost.paginate(page: params[:page], :per_page => 10)
		else
			@blog_posts = BlogPost.where(public: true).paginate(page: params[:page], :per_page => 10)
		end
	end
end