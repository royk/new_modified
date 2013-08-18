class AchievementsController  < AuthenticatedController
	include VideoHelper
	before_filter	:correct_user, only: [:destroy, :update]
	skip_before_filter :signed_in_user, only: [:index, :show]

	def show
		@achievement = Achievement.find(params[:id])
		if @achievement!=nil && !signed_in? && !@achievement.public
			signed_in_user
		end
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
					if @achievement.updated_at>=Date.yesterday
						register_new_content(@achievement)
					end
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
		unless params[:achievement][:date].nil?
			begin
				params[:achievement][:date] = DateTime.strptime(params[:achievement][:date], "%m/%d/%Y")
			rescue
				success = false
				message = "Failed saving achievement: Invalid date."
			end
		end
		if success
			@achievement.update_attributes(params[:achievement])
			@achievement.record_timestamps = false
			@achievement.updated_at = @achievement.date
			unless params[:video].nil?
				attach_video(@achievement, params)
			end
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