class LikesController < ResponseController

	def create
		unless super
			logger.error "ERROR: LikesController.create: #{params.inspect}"
		end
		render_result
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
		@parent = find_parent
		if @parent
			res = @parent.likes.where("liker_id = "+current_user.id.to_s)
			res.first.destroy if res.any?
			render_result
		else
			render :status => 500
		end
	end

	private
		def render_result
			if params[:parent_type]=="Comment"
				render_comment_footer
			else
				render_post
			end
		end
		def render_post
			render partial: 'shared/feed_item_internal', locals: {feed_item: @parent, feed_item_counter: params[:index]}
		end

		def render_comment_footer
			render partial: 'comments/comment_footer', locals: {comment: @parent, comment_counter: params[:index]}
		end

end