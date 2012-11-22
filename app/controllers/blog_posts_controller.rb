class BlogPostsController < AuthenticatedController
	before_filter	:correct_user,	only: [:edit, :update]

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