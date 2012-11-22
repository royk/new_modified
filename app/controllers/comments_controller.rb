class CommentsController < ResponseController
	before_filter	:correct_user, only: :destroy

	def create
		if super
		flash[:success] = "Comment posted!"
		else
			flash[:error] = "Error posting comment."
		end	
		redirect_to root_url
	end

	def response_object
		"comment"
	end

	def creator_object
		"commenter"
	end

	private
		def begin_of_association_chain
			@parent
		end

		def correct_user
			if !current_user.admin?
				@comment = current_user.comments.find_by_id(params[:id])
				redirect_to root_url if @comment.nil?
			end
		end
end