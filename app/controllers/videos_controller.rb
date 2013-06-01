class VideosController < AuthenticatedController
	include ContentControls
	include VideoMatchers
	include VideoImporters
	
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
			@videos = Video.where("#{compound_privacy_query} for_feedback = ? ", false).paginate(page: params[:page], :per_page => 20)
			if request.xhr?
				render partial: 'shared/videos/small/small_video_item', collection: @videos, comments_shown: false
			end
		end
	end

	def feedback_index
		@videos = Video.where("#{compound_privacy_query} for_feedback = ? ", true).paginate(page: params[:page], :per_page => 10)
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
		update_players
		if save_video(@video.url)
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
		update_players
		@video.update_attribute(:public, params[:video][:public]) unless params[:video][:public].nil?
		save_video(params[:video][:url]) unless params[:video][:url].nil?
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

		def update_players
			user_players = @video.user_players.dup
			@video.remove_players
			i=0
			until params[("Player_"+i.to_s).to_sym].nil?
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
			set_video_url(@video, url)
			unless @video.uid.nil?
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
				@video.tag_list.remove(@video.title.split(/\W+/)) unless @video.title.empty?
				@video.title = params[:video][:title]
				@video.title.split(/\W+/).each { |w| @video.tag_list << w } unless @video.title.empty?
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

		
end