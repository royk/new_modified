class BlogPostsController < AuthenticatedController
	before_filter	:correct_user,	only: [:edit, :update]
	skip_before_filter :signed_in_user, only: [:index, :show]

	def show
		@blog_post = BlogPost.find(params[:id])
		if !signed_in? && @blog_post.public==false
    		@blog_post = nil
    		redirect_to root_url
		end
	end

	def index
		@blog_posts = privacy_query(BlogPost).paginate(page: params[:page], :per_page => 10)
	end

	def create
		if current_user.blog.nil?
			create_blog
		end
		create! do |success, failure|
			success.html do 
				notify_activity_on(@blog_post, current_user, nil)
				redirect_to root_url
			end
			failure.html do
				redirect_to root_url
			end
		end
	end

	private
		def begin_of_association_chain
			current_user.blog
		end

		def create_blog
			current_user.build_blog(title: "My new blog")
			current_user.blog.save
		end

		def correct_user
			if !current_user.admin?
	        	@blogPost = BlogPost.find(params[:id])
	        	redirect_to(root_path) unless current_user?(@blogPost.user)
			end
		end
end