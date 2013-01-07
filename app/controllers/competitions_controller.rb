class CompetitionsController < AuthenticatedController
	skip_before_filter :signed_in_user, only: [:show]

	def show
		@competition = Competition.find(params[:id])
		unless @competition.nil?
			if signed_in?
				@result = Result.where("user_id = ? AND competition_id = ?", current_user.id, @competition.id).first
				@result = Result.new if @result.nil?
			end
		end
	end
end