class CommentsController < ApplicationController
	before_filter	:signed_in_user,	only: [:create, :destroy]
	before_filter	:correct_user, only: :destroy

	def new
		@comment = @parent.comments.new
	end

	def create
		if params[:parent_type]=="Video"
			parent = Video.find(params[:parent_id])
		end
		if params[:parent_type]=="Post"
			parent = Post.find(params[:parent_id])
		end
		if parent
			@comment = parent.comments.build(params[:comment])
			@comment.commenter = current_user
			notify_comment_on(parent, @comment)
		else
			flash[:error] = params[:parent_type]
		end
		if @comment
			if @comment.save
				flash[:success] = "Comment posted"
			end
		end
		redirect_to root_url
	end

	def notify_comment_on(item, action)
		if current_user!=item.user
			notification = item.user.notifications.build(sender_id: current_user.id)
			notification.user = item.user
			notification.item = item
			notification.action = action
			notification.public = false
			notification.save
		end
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