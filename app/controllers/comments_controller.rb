class CommentsController < ResponseController
	before_filter	:correct_user, only: [:destroy, :update]

	def create
		if super
			@parent.save # mark the parent component as updated
			flash[:success] = "Comment posted!"
			# register commenter as a listener to the original post
			if @parent.listeners.find_by_user_id(current_user).nil?
				listener = @parent.listeners.build(user: current_user)
				listener.save
			end
			# send notification email to listeners
			if @parent.respond_to?(:listeners) && !@parent.listeners.nil?
				@parent.listeners.each do |listener|
					UserMailer.listener_mail(listener).deliver	unless current_user==listener.user # don't send notification when I write on my own stuff
				end
			end
		else
			flash[:error] = params[:parent_type]
		end	
		redirect_to request.referer
	end

	def update
		update! { request.referer }
	end

	def response_object
		"comment"
	end

	def creator_object
		"commenter"
	end

	def attached_item
		"commentable"
	end

	def show
		@comment = Comment.find(params[:id])
		if @comment.nil?
			redirect_to root_url
		else
			redirect_to polymorphic_path(@comment.commentable)
		end
	end

	private
		def begin_of_association_chain
			@parent
		end

		def correct_user
			if !current_user.admin?
				comment = Comment.find(params[:id])
				unless comment.commenter.id==current_user.id
					redirect_to root_url
				end
			end
		end
end