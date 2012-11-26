class LikesController < ResponseController

	def create
		if super
			if request.xhr?
				render partial: 'shared/feed_item', locals: {feed_item: @parent}
				return
			else
				flash[:success] = "Kudos given!"
			end
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

	def destroy
		parent = find_parent
		if parent
			res = parent.likes.where("liker_id = "+current_user.id.to_s)
			res.first.destroy if res.any? && res.first.liker.id==current_user.id
			if request.xhr?
				render partial: 'shared/feed_item', locals: {feed_item: parent}
				return
			else
				flash[:success] = "Kudos removed"
			end
		end
		redirect_to root_url
	end

end