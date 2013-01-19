class ResponseController < AuthenticatedController

	def find_parent
		if params[:parent_type]=="Video"
			return Video.find(params[:parent_id])
		end
		if params[:parent_type]=="Post"
			return Post.find(params[:parent_id])
		end
		if params[:parent_type]=="BlogPost"
			return BlogPost.find(params[:parent_id])
		end
		if params[:parent_type]=="Comment"
			return Comment.find(params[:parent_id])
		end
	end

	def create
		@parent = find_parent
		if @parent
			collection = @parent.send(response_object.pluralize || response_collection)
			if collection
				@response = collection.build(params[response_object.to_sym])
				@response.send("#{creator_object}=", current_user)
				@response.send("#{attached_item}=", @parent)
				register_new_content(@response, @parent)
				@parent.touch
				if @response.save
					
					return true
				end
			end
		end
		false
	end

	def destroy
		destroy! { root_url }
	end


	def response_object
		""
	end

	def response_collection
		nil
	end

	def creator_object
		"user"
	end

	def attached_item
		"item"
	end

	def test_uniqueness(collection)
		true
	end
end