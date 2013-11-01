class PostsController < AuthenticatedController
	include ContentControls

	before_filter	:correct_user, only: [:destroy, :edit]
	skip_before_filter :signed_in_user, only: [:index, :show]

	def show
    	@post = get_item(Post, params)
	end

	def edit
		@post = Post.find(params[:id])
		edit! { request.referer }
	end

	def create
		create! do |success, failure|
			success.html do 
				listener = Listener.new
				listener.user = current_user
				listener.listened_to = @post
				listener.save
				register_new_content(@post)
				redirect_to request.referer
			end
			failure.html do
				redirect_to request.referer
			end
		end
	end

	def index
    redirect_to root_url
	end

	def update
		@post = Post.find(params[:id])
		@post.record_timestamps = false if current_user.admin? && @post.user!=current_user
		update! { request.referer }
		@post.record_timestamps = true
	end

	def destroy
		@post = Post.find(params[:id])
		destroy! { request.referer }
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