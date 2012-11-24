class PostsController < AuthenticatedController
	
	before_filter	:correct_user, only: :destroy
	skip_before_filter :signed_in_user, only: [:index, :show]
	
	def create
		create! do |success, failure|
			success.html do 
				notify_activity_on(@post, current_user, nil)
				redirect_to root_url
			end
			failure.html do
				redirect_to root_url
			end
		end
	end

	def index
		@posts = privacy_query(Post).paginate(page: params[:page], :per_page => 10)
	end

	def update
		update! { root_url }
	end

	def destroy
		destroy! { root_url }
	end

	private
		def begin_of_association_chain
			current_user
		end

		def correct_user
			if !current_user.admin?
				@post = current_user.posts.find_by_id(params[:id])
				redirect_to root_url if @post.nil?
			end
		end
end