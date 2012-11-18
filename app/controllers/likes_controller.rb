class LikesController < ApplicationController
	before_filter	:signed_in_user,	only: [:create, :destroy]
	before_filter	:correct_user, only: :destroy

	def new
		@like = @parent.likes.new
	end

	def create
		if params[:parent_type]=="Video"
			parent = Video.find(params[:parent_id])
		end
		if params[:parent_type]=="Post"
			parent = Post.find(params[:parent_id])
		end
		if parent
			if parent.likes.find_by_liker_id(current_user.id).nil?
				@like = parent.likes.build(params[:like])
				@like.liker = current_user
				notify_like_on(parent, @like)
			else
				flash[:error] = "Kudos already given"
			end
		else
			flash[:error] = params[:parent_type]
		end
		if @like
			if @like.save
				flash[:success] = "Kudos given!"
			end
		end
		redirect_to root_url
	end

	def notify_like_on(item, action)
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
		Like.find(params[:id]).destroy
		flash[:success] = "Unliked"
		redirect_to root_url
	end
	private
		def correct_user
			if !current_user.admin?
				@like = current_user.likes.find_by_id(params[:id])
				redirect_to root_url if @post.nil?
			end
		end
end