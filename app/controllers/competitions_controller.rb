class CompetitionsController < AuthenticatedController
	skip_before_filter :signed_in_user, only: [:show]
	include VideoMatchers
	def show
		@competition = Competition.find(params[:id])
	end
end