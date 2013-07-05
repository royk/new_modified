class AchievementsController  < AuthenticatedController
	def new
		new! { request.referer }
	end

	def create
		@achievement = current_user.achievements.build(params[:achievement])
		if @achievement.save
			flash[:success] = "Achievement saved"
			register_new_content(@achievement)
		end
		redirect_to request.referer
	end
end