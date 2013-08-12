class VideoCategoriesController < AuthenticatedController
	before_filter :admin_only

	skip_before_filter :signed_in_user, only: [:index]

	skip_before_filter :admin_only, only: [:index]

	def show
		@video_category = VideoCategory.find_by_permalink(params[:id])
		if @video_category.nil?
			@videos = nil
		else
			if signed_in?
				@videos = Video.where("video_category_id = ? AND for_feedback = ? ", @video_category.id, false).paginate(page: params[:page], :per_page => 20)
			else
				@videos = Video.where("video_category_id = ? AND public = ? AND for_feedback = ? ", @video_category.id, true, false).paginate(page: params[:page], :per_page => 20)
			end
		end
		if request.xhr?
			render partial: 'shared/videos/small/small_video_item', collection: @videos, comments_shown: false
		end
	end

	def create
		video_category = VideoCategory.new(params[:video_category])
		if video_category.save
			flash[:success] = "Created video category #{video_category.name}"
			redirect_to root_url
		else
			flash[:error] = "Couldn't create video category!"
			render 'new'
		end
	end

	def new
		@video_category = VideoCategory.new
	end

	private
	def admin_only
		redirect_to root_url unless current_user.admin?
	end

end