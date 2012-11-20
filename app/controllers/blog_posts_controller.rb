class BlogPostsController < ApplicationController
	before_filter	:signed_in_user,	only: [:create, :destroy]

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
end