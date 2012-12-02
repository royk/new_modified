class LikesController < ResponseController

	def create
		if super
			render partial: 'shared/feed_item_internal', locals: {feed_item: find_parent, feed_item_counter: params[:index]}
		else
			logger.error "ERROR: LikesController.create: #{params.inspect}"
			redirect_to request.referer
		end
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

	def destroy
		parent = find_parent
		if parent
			res = parent.likes.where("liker_id = "+current_user.id.to_s)
			res.first.destroy if res.any? && res.first.liker.id==current_user.id
			render partial: 'shared/feed_item_internal', locals: {feed_item: parent, feed_item_counter: params[:index]}
		else
			logger.error "ERROR: LikesController.delete: #{params.inspect}"
			render :status => 500
		end
	end

end