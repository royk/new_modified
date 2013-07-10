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
		params[:achievement][:date] = DateTime.strptime(params[:achievement][:date], "%m/%d/%Y")
		@achievement = current_user.achievements.build(params[:achievement])
		@achievement.record_timestamps = false
		@achievement.created_at = DateTime.now
		@achievement.updated_at = @achievement.date
		if attach_video(@achievement, params)
			if @achievement.save
				flash[:success] = "Achievement saved"
				register_new_content(@achievement)
			else
				flash[:error] = "Failed saving achievement. Please make sure you filled all the required information." if flash[:error].blank?
			end
		end
		@achievement.record_timestamps = true
		render text: ""
	end

	def update
		params[:achievement][:date] = DateTime.strptime(params[:achievement][:date], "%m/%d/%Y")
		@achievement.update_attributes(params[:achievement])
		@achievement.record_timestamps = false
		@achievement.updated_at = @achievement.date
		attach_video(@achievement, params)
		if @achievement.save
			flash[:success] = "Achievement updated"
		else
			flash[:error] = "Failed saving achievement. Please make sure you filled all the required information." if flash[:error].blank?
		end
		@achievement.record_timestamps = true
		render text: ""

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