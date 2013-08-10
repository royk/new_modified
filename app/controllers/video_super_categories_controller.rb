class VideoSuperCategoriesController < AuthenticatedController
	before_filter :admin_only

	skip_before_filter :signed_in_user, only: [:index]

	skip_before_filter :admin_only, only: [:index]

	def show
		@video_super_category = VideoSuperCategory.find(params[:id])
		@videos = nil
		unless @video_super_category.nil?
			@video_categories = VideoCategory.where("video_super_category_id = ?", @video_super_category.id)
			unless @video_categories.nil? || @video_categories.empty?
				@video_categories.each do |cat|
					if signed_in?
						videos = Video.where("video_category_id = ? AND for_feedback = ? ", @video_category.id, false)
					else
						videos = Video.where("video_category_id = ? AND public = ? AND for_feedback = ? ", @video_category.id, true, false)
					end
					if @videos.nil?
						@videos = videos
					else
						@videos = @videos + videos
					end
				end
			end
		end
	end

	def create
		video_super_category = VideoSuperCategory.new(params[:video_super_category])
		if video_super_category.save
			flash[:success] = "Created video super category #{video_super_category.name}"
			redirect_to root_url
		else
			flash[:error] = "Couldn't create video super category!"
			render 'new'
		end
	end

	def new
		@video_super_category = VideoSuperCategory.new
	end

	private
	def admin_only
		redirect_to root_url unless current_user.admin?
	end

end
