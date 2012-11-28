class CommentsController < ResponseController
	before_filter	:correct_user, only: [:destroy, :update]

	def create
		if super
		flash[:success] = "Comment posted!"
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