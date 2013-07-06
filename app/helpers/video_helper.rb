module VideoHelper
	include VideoMatchers
	def update_players(video, params)
		user_players =video.user_players.dup
		video.remove_players
		i=0
		until params[("Player_"+i.to_s).to_sym].nil?
			name = params[("Player_"+i.to_s).to_sym]
			unless name.empty?
				player = video.add_player name
				if player
					notify_tag(video, current_user, player) unless user_players.include? player
				end
			end
			i += 1
		end
	end

	def save_video(video, url)
		set_video_url(video, url)
		unless video.uid.nil?
			video.tag_list = [] if video.tag_list.nil?
			update_video_title(video)
			if video.save
				return true
			else
				flash[:error] = "Video not saved: Already exists"
			end
		else
			flash[:error] = "Unrecognized Video URL"
		end
		return false
	end

	def update_video_title(video)
		unless params[:video][:title].nil?
			video.tag_list.remove(video.title.split(/\W+/)) unless video.title.empty?
			video.title = params[:video][:title]
			video.title.split(/\W+/).each { |w| video.tag_list << w } unless video.title.empty?
		end
	end
end