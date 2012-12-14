class VideosController < AuthenticatedController
	include ContentControls
	include VideoScrapers
	
	before_filter	:correct_user, only: [:destroy, :update]
	skip_before_filter :signed_in_user, only: [:index, :show]

	def show
    	@video = get_item(Video, params)
	end

	def index
		if /atom/.match(request.format)
			@videos = privacy_query(Video)
		else
			@videos = privacy_query(Video).paginate(page: params[:page], :per_page => 10)
			if request.xhr?
				render partial: 'shared/feed_item', collection: @videos, comments_shown: false
			end
		end
	end
	
	def create
		@video = current_user.videos.build(params[:video])
		update_players
		if save_video(@video.url)
			flash[:success] = "Video created"
			notify_activity_on(@video, current_user, nil)
		end
		redirect_to request.referer
	end
=begin	
# imports videos from jsViewFeed
	def import
		videos = params[:videos]
		videos.each do |v|
			video = v[1]
			
			if video[:deleted]=="0"
				@video = Video.find_by_uid(video[:src])
				if @video.nil?
					@video = current_user.videos.build()
				end
				@video.title = video[:title]
				@video.vendor = video[:type]
				@video.uid = video[:src]
				@video.location = video[:location]
				@video.created_at = video[:date]
				@video.updated_at = video[:date]
				@video.maker = video[:maker]
				@video.players = []
				_players = video[:players].split(' ')
				@video.tag_list = []
				if _players.any?
					index = 0
					for player in _players
						@video.tag_list << player
						if index%2==0
							p = player
							p << " "
						else
							p << player
							@video.players << p
						end
						index = index + 1
					end
					
				end
				tags = video[:tags].split(' ')
				@video.tag_list = @video.tag_list + tags
				@video.save
			end
		end
		redirect_to request.referer
	end
=end

	def update
		update_players
		@video.update_attribute(:public, params[:video][:public]) unless params[:video][:public].nil?
		save_video(params[:video][:url]) unless params[:video][:url].nil?
		flash[:success] = "Video modified"
		redirect_to request.referer
	end

	def destroy
		@video.destroy
		flash[:success] = "Video deleted"
		redirect_to request.referer
	end

	def search
		@videos = Video.tagged_with(params[:search])#.by_date.paginate(:page => params[:page], :per_page => 20)
	end

	private

		def update_players
			user_players = @video.user_players.dup
			@video.remove_players
			i=0
			until params[("Player_"+i.to_s).to_sym].nil?
				logger.debug "Index #{i}"
				name = params[("Player_"+i.to_s).to_sym]
				unless name.empty?
					player = @video.add_player name 
					if player
						notify_tag(@video, current_user, player) unless user_players.include? player
					end
				end
				i += 1
			end
		end

		def save_video(url)
			uid_vendor = get_uid_vendor(url)
			if uid_vendor
				@video.url = url
				@video.vendor = uid_vendor[:vendor]
				@video.uid = uid_vendor[:uid]
				@video.tag_list = [] if @video.tag_list.nil?
				update_video_title
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

		def update_video_title
			unless params[:video][:title].nil?
				@video.tag_list.remove(@video.title)
				@video.title = params[:video][:title] 
				@video.tag_list << @video.title unless @video.title.empty?
			end
		end

		def correct_user
			unless current_user.admin?
				@video = current_user.videos.find_by_id(params[:id])
				redirect_to root_url if @video.nil?
			else
				@video = Video.find(params[:id])
			end
		end

		def get_uid_vendor(url)
			vimeoID = url.scan(/vimeo\.com\/(\d+)$/i)
			youtubeIDLong = url.scan(/(?:youtube\.com\/watch[^\s]*[\?&]v=)([\w-]+)/i);
			youtubeIdShort = url.scan(/(?:youtu\.be\/)([\w-]+)/i)
			ret = false
			ret = {uid: vimeoID[0][0], vendor: "vimeo"} if vimeoID.any?
			ret = {uid: youtubeIDLong[0][0], vendor: "youtube"} if youtubeIDLong.any?
			ret = {uid: youtubeIdShort[0][0], vendor: "youtube"} if youtubeIdShort.any?
			unless ret==true
				if url.match(/footbag.org/i)
					footbagorg = footbagorg_scrape(url)
					if footbagorg
						footbagorg = footbagorg.scan(/v.footbag.org\/media\/(\d+)\/(.+)/i);
						ret = {uid: "#{footbagorg[0][0]}/#{footbagorg[0][1]}", vendor: "footbagorg"} if footbagorg.any?
					end
				end
			end
			return ret
		end
end