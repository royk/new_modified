class BlogsController < AuthenticatedController
	skip_before_filter :signed_in_user, only: [:index, :show]
	
	def index
		@blogs = Blog.paginate(page: params[:page], :per_page => 10)

	end

	def show
		@blog = Blog.find(params[:id])
		@blog_posts = privacy_query(@blog.blog_posts).paginate(page: params[:page], :per_page => 10)
		if request.xhr?
			render partial: 'shared/feed_item', collection: @blog_posts, comments_shown: false
		end
	end
end