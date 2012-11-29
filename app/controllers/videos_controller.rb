class VideosController < AuthenticatedController
	before_filter	:correct_user, only: [:destroy, :update]
	skip_before_filter :signed_in_user, only: [:index, :show]

	def show
    	@video = Video.find(params[:id])
    	if !signed_in? && @video.public==false
    		@video = nil
    		redirect_to root_url
    	end
	end

	def index
		@videos = privacy_query(Video).paginate(page: params[:page], :per_page => 10)
		if request.xhr?
			render partial: 'shared/feed_item', collection: @videos, comments_shown: false
		end
	end
	
	def create
		@video = current_user.videos.build(params[:video])
		@video.user_id = current_user.id
		i=0
		arr = []
		@video.players = ""
		until params[("Player_"+i.to_s).to_sym].nil?
			name = params[("Player_"+i.to_s).to_sym]
			player = User.where('lower(name) = ?', name.downcase).first
			unless player.nil?
				player = player
				@video.user_players << player
				
				player.appears_in_videos << @video
			else
				arr << name
			end
			i += 1
		end
		@video.players = arr
		uid_vendor = get_uid_vendor(@video.url) if @video.url
		if save_video(uid_vendor)
			flash[:success] = "Video created"
			notify_activity_on(@video, current_user, nil)
		end
		redirect_to request.referer
	end

	def update
		@video = Video.find(params[:id])
		if params[:video][:url].nil? && !params[:video][:public].nil?
			success = @video.update_attribute(:public, params[:video][:public])
		else
			uid_vendor = get_uid_vendor(params[:video][:url])
			@video.url = params[:video][:url]
			success = save_video(uid_vendor)
		end
		if success
			flash[:success] = "Video modified"
		end
		redirect_to request.referer
	end

	def destroy
		Video.find(params[:id]).destroy
		flash[:success] = "Video deleted"
		redirect_to request.referer
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