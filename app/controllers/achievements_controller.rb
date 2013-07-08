class AchievementsController  < AuthenticatedController
	include VideoHelper

	def show
		@achievement = Achievement.find(params[:id])
	end

	def new
		new! { request.referer }
	end

	def create
		params[:achievement][:date] = DateTime.strptime(params[:achievement][:date], "%m/%d/%Y")
		@achievement = current_user.achievements.build(params[:achievement])
		@achievement.record_timestamps = false
		@achievement.created_at = DateTime.now
		@achievement.updated_at = @achievement.date
		if attach_video(@achievement, params)
			if @achievement.save
				@achievement.record_timestamps = true
				flash[:success] = "Achievement saved"
				register_new_content(@achievement)
			else
				flash[:error] = "Failed saving achievement. Please make sure you filled all the required information." if flash[:error].blank?
			end
		end
		render text: ""
	end
end