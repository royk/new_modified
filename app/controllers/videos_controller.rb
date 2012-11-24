class VideosController < AuthenticatedController
	before_filter	:correct_user, only: [:destroy, :update]

	def show
    	@video = Video.find(params[:id])
	end

	def index
		@videos = Video.paginate(page: params[:page], :per_page => 10)
	end
	
	def create
		@video = current_user.videos.build(params[:video])
		@video.user_id = current_user.id
		uid_vendor = get_uid_vendor(@video.url) if @video.url
		if save_video(uid_vendor)
			flash[:success] = "Video created"
			notify_activity_on(@video, current_user, nil)
		end
		redirect_to root_url
	end

	def update
		@video = Video.find(params[:id])
		uid_vendor = get_uid_vendor(params[:video][:url])
		@video.url = params[:video][:url]
		if save_video(uid_vendor)
			flash[:success] = "Video modified"
			redirect_to @video
		else
			redirect_to root_url
		end
	end

	def destroy
		Video.find(params[:id]).destroy
		flash[:success] = "Video deleted"
		redirect_to root_url
	end

	private

		def save_video(uid_vendor)
			if uid_vendor
				@video.vendor = uid_vendor[:vendor]
				@video.uid = uid_vendor[:uid]
				if @video.save
					return true
				else
					flash[:error] = "Video not saved: Already exists"
				end
			else
				flash[:error] = "Unrecognized Video URL"
			end
			return false
		end

		def correct_user
			if !current_user.admin?
				@video = current_user.videos.find_by_id(params[:id])
				redirect_to root_url if @video.nil?
			end
		end

		def get_uid_vendor(url)
			vimeoID = url.scan(/vimeo\.com\/(\d+)$/i)
			youtubeIDLong = url.scan(/(?:youtube\.com\/watch[^\s]*[\?&]v=)([\w-]+)/i);
			youtubeIdShort = url.scan(/(?:youtu\.be\/)([\w-]+)/i)
			ret = false
			if vimeoID.any?
				ret = {uid: vimeoID[0][0], vendor: "vimeo"}
			end
			if youtubeIDLong.any?
				ret = {uid: youtubeIDLong[0][0], vendor: "youtube"}
			end
			if youtubeIdShort.any?
				ret = {uid: youtubeIdShort[0][0], vendor: "youtube"}
			end
			return ret
		end
end