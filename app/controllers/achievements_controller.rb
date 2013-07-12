class AchievementsController  < AuthenticatedController
	include VideoHelper
	before_filter	:correct_user, only: [:destroy, :update]

	def show
		@achievement = Achievement.find(params[:id])
	end

	def new
		new! { request.referer }
	end

	def create
		success = true
		begin
			params[:achievement][:date] = DateTime.strptime(params[:achievement][:date], "%m/%d/%Y")
		rescue
			success = false
			message = "Failed saving achievement: Invalid date."
		end
		if success
			@achievement = current_user.achievements.build(params[:achievement])
			@achievement.record_timestamps = false
			@achievement.created_at = DateTime.now
			@achievement.updated_at = @achievement.date
			success = attach_video(@achievement, params)
			if success
				success = @achievement.save
				if success
					message = "Achievement saved"
					register_new_content(@achievement)
				end
			end
			@achievement.record_timestamps = true
		end

		unless success
			message = flash[:error].blank? ? "Failed saving Achievement. Please make sure you filled all the required information." : flash[:error]
		end
		render json: {message: message, success:success}
	end

	def update
		success = true
		begin
			params[:achievement][:date] = DateTime.strptime(params[:achievement][:date], "%m/%d/%Y")
		rescue
			success = false
			message = "Failed saving achievement: Invalid date."
		end
		if success
			@achievement.update_attributes(params[:achievement])
			@achievement.record_timestamps = false
			@achievement.updated_at = @achievement.date
			attach_video(@achievement, params)
			success = @achievement.save
			if success
				message = "Achievement updated"
			else
				message = flash[:error].blank? ? "Failed updating Achievement. Please make sure you filled all the required information." : flash[:error]
			end
			@achievement.record_timestamps = true
		end
		render json: {message: message, success:success}

	end

	def destroy
		@achievement.destroy
		flash[:success] = "Achievement deleted"
		redirect_to root_url
	end

	private


	def correct_user
		unless current_user.admin?
			@achievement = current_user.achievements.find_by_id(params[:id])
			redirect_to root_url if @achievement.nil?
		else
			@achievement = Achievement.find(params[:id])
		end
	end
end