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
	end
end