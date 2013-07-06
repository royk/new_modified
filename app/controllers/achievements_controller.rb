class AchievementsController  < AuthenticatedController
	include VideoHelper
	def new
		new! { request.referer }
	end

	def create
		@achievement = current_user.achievements.build(params[:achievement])
		can_continue = true
		unless params[:video][:url]==""
			@achievement.video = Video.new
			@achievement.video.update_attributes(params[:video])
			@achievement.video.user = current_user
			can_continue = save_video(@achievement.video,@achievement.video.url)
			if can_continue
				update_players(@achievement.video, params)
				@achievement.video_id = @achievement.video.id
			end
		end
		if can_continue
			if @achievement.save
				flash[:success] = "Achievement saved"
				register_new_content(@achievement)
			end
		end
		redirect_to request.referer
	end
end