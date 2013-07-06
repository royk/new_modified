class VideosController < AuthenticatedController
	include ContentControls

	include VideoImporters
	include VideoHelper
	
	before_filter	:correct_user, only: [:destroy, :update]
	skip_before_filter :signed_in_user, only: [:index, :show, :feedback_index, :search]
	before_filter :check_for_mobile, only: [:index, :search]

	def show
    	@video = get_item(Video, params)
	end

	def index
		if /atom/.match(request.format)
			@videos = Video.where("public = ? AND for_feedback = ? ", true, false)
		else
			if signed_in?
				@videos = Video.where("for_feedback = ? ", false).paginate(page: params[:page], :per_page => 20)
			else
				@videos = Video.where("public = ? AND for_feedback = ? ", true, false).paginate(page: params[:page], :per_page => 20)
			end
			if request.xhr?
				render partial: 'shared/videos/small/small_video_item', collection: @videos, comments_shown: false
			end
		end
	end

	def feedback_index
		if signed_in?
			@videos = Video.where("for_feedback = ? ", true).paginate(page: params[:page], :per_page => 20)
		else
			@videos = Video.where("public = ? AND for_feedback = ? ", true, true).paginate(page: params[:page], :per_page => 20)
		end
		if request.xhr?
			render partial: 'shared/videos/small/small_video_item', collection: @videos, comments_shown: false
		end
	end
	
	def create
		if params[:anonymous]
			@video = Video.new
			@video.update_attributes(params[:video])
		else
			@video = current_user.videos.build(params[:video])
		end
		update_players(@video, params)
		if save_video(@video, @video.url)
			flash[:success] = "Video created"
			register_new_content(@video)
		end
		redirect_to request.referer
	end

	def import
		import_footbagIsrael(params[:videos])
		redirect_to request.referer
	end

	def update
		@video.record_timestamps = false if current_user.admin? && @video.user!=current_user
		update_players(@video, params)
		@video.update_attribute(:public, params[:video][:public]) unless params[:video][:public].nil?
		save_video(@video, params[:video][:url]) unless params[:video][:url].nil?
		flash[:success] = "Video modified"
		@video.record_timestamps = true
		redirect_to request.referer
	end

	def destroy
		@video.destroy
		flash[:success] = "Video deleted"
		redirect_to request.referer
	end

	def search
		@videos = Video.tagged_with(params[:search]).paginate(page: params[:page], :per_page => 20)
	end

	private


		def correct_user
			unless current_user.admin?
				@video = current_user.videos.find_by_id(params[:id])
				redirect_to root_url if @video.nil?
			else
				@video = Video.find(params[:id])
			end
		end

		
end