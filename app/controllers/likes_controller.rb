class LikesController < ResponseController
	before_filter	:correct_user, only: :destroy

	def create
		if super
			flash[:success] = "Kudos given!"
		else
			flash[:error] = "Kudos already given!"
		end
		redirect_to root_url
	end

	def response_object
		"like"
	end

	def creator_object
		"liker"
	end

	def attached_item
		"liked_item"
	end

	def test_uniqueness(collection)
		collection.find_by_liker_id(current_user.id).nil?
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
				redirect_to root_url if @like.nil?
			end
		end
end