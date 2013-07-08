class TrainingSessionsController  < AuthenticatedController
	include VideoHelper

	def show
		@trainingSession = TrainingSession.find(params[:id])
	end

	def new
		new! { request.referer }
	end

	def create
		@trainingSession = current_user.training_sessions.build(params[:training_session])
		if attach_video(@trainingSession, params) && @trainingSession.save
			flash[:success] = "Session saved"
		else
			flash[:error] = "Failed saving Session. Please make sure you filled all the required information." if flash[:error].blank?
		end
		redirect_to request.referer
	end
end