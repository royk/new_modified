class VideosController < AuthenticatedController
	before_filter	:correct_user, only: :destroy

	def show
    	@video = Video.find(params[:id])
	end

	def index
		@videos = Video.paginate(page: params[:page], :per_page => 10)
	end
	
	def create
		@video = current_user.videos.build(params[:video])
		@video.user_id = current_user.id
		if parse_video
			if @video.save
				notify_activity_on(@video, current_user, nil)
				flash[:success] = "Video created"
			else
				flash[:error] = "Video not saved: Already exists"
			end
		else
			flash[:error] = "Unrecognized Video URL"
		end
		redirect_to root_url
	end

	def destroy
		Video.find(params[:id]).destroy
		flash[:success] = "Video deleted"
		redirect_to root_url
	end

	private
		def correct_user
			if !current_user.admin?
				@video = current_user.videos.find_by_id(params[:id])
				redirect_to root_url if @video.nil?
			end
		end

		def parse_video
			vimeoID = @video.url.scan(/vimeo\.com\/(\d+)$/i)
			youtubeIDLong = @video.url.scan(/(?:youtube\.com\/watch[^\s]*[\?&]v=)([\w-]+)/i);
			youtubeIdShort = @video.url.scan(/(?:youtu\.be\/)([\w-]+)/i)
			ret = false
			if vimeoID.any?
				@video.uid = vimeoID[0][0]
				@video.vendor = "vimeo"
				ret = true
			end
			if youtubeIDLong.any?
				@video.uid = youtubeIDLong[0][0]
				@video.vendor = "youtube"
				ret = true
			end
			if youtubeIdShort.any?
				@video.uid = youtubeIdShort[0][0]
				@video.vendor = "youtube"
				ret = true
			end
			return ret
		end
end