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

	def attach_video(entity, params)
		success = true
		unless params[:video][:url]==""
			video_uid = get_uid_vendor(params[:video][:url])[:uid]
			existing_video = Video.find_by_uid(video_uid)
			if existing_video
				entity.video = existing_video
				entity.video_id = entity.video.id
			else
				entity.video = Video.new
				entity.video.update_attributes(params[:video])
				entity.video.user = current_user
				entity.video.feed_id = 0
				update_players(entity.video, params[:players])
				success = save_video(entity.video,entity.video.url)
				if success
					entity.video_id = entity.video.id
				end
			end
		end
		return success
	end
end