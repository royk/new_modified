class ResultsController < AuthenticatedController
	def create
		@user = User.find_by_name(params[:user_name])
		unless @user.nil?
			@result = Result.create(user: @user, competition_id: params[:competition_id])
			@result.update_attributes(params[:result])
			if @result.save
				flash[:success] = "Added competition result"
			else
				flash[:error] = "Couldn't add competition result"
			end
		end
		redirect_to request.referer
	end
end