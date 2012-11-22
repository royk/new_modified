class BlogPostsController < AuthenticatedController
	before_filter	:correct_user,	only: [:edit, :update]

	def edit
		@blogPost = BlogPost.find(params[:id])
	end

	def update
	end

	def create
		if current_user.blog.nil?
			create_blog
		end
		@blogPost = current_user.blog.blog_posts.build(params[:blog_post])
		if @blogPost.save
			notify_activity_on(@blogPost, current_user, nil)
			flash[:success] = "Blog post created"
		else
			flash[:error] = "Failed posting to blog"
		end
		redirect_to root_url
	end

	def show
		@blog_post = BlogPost.find(params[:id])
	end

	private
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