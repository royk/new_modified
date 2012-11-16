class CommentsController < ApplicationController
	before_filter	:signed_in_user,	only: [:create, :destroy]
	before_filter	:correct_user, only: :destroy

	def new
		@comment = @parent.comments.new
	end

	def create
		if params[:parent_type]=="video"
			parent = Video.find(params[:parent_id])
		end
		if parent
			@comment = parent.comments.build(params[:comment])
			@comment.commenter = current_user
		else
			flash[:error] = "you suck"
		end
		if @comment.save
			flash[:success] = "Comment posted"
		end
		redirect_to root_url
	end

	def destroy
		Comment.find(params[:id]).destroy
		flash[:success] = "Comment removed"
		redirect_to root_url
	end
	private
		def correct_user
			if !current_user.admin?
				@comment = current_user.comments.find_by_id(params[:id])
				redirect_to root_url if @post.nil?
			end
		end
end