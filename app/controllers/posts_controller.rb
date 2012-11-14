class PostsController < ApplicationController
	
	before_filter	:signed_in_user,	only: [:create, :destroy]
	before_filter	:correct_user, only: :destroy
	

	def create
		@post = current_user.posts.build(params[:post])
		@post.user_id = current_user.id
		if @post.save
			flash[:success] = "Post created"
		else
			flash[:error] = "Post not saved."
		end
		redirect_to root_url
	end

	def destroy
		Post.find(params[:id]).destroy
		redirect_to root_url
	end

	private
		def correct_user
			if !current_user.admin?
				@post = current_user.posts.find_by_id(params[:id])
				redirect_to root_url if @post.nil?
			end
		end
end