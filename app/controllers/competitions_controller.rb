class CompetitionsController < AuthenticatedController
	skip_before_filter :signed_in_user, only: [:show]
	include VideoMatchers
	def show
		@competition = Competition.find(params[:id])
	end

	def reorder
		competition = Competition.find(params[:id])
		replace_with = Competition.where("event_id = ? AND order_index = ?", competition.event_id, params[:order_index]).first
		unless replace_with.nil?
			old_index = competition.order_index
			competition.order_index = replace_with.order_index
			replace_with.order_index = old_index
			replace_with.save
		else
			competition.order_index = params[:order_index]
		end
		competition.save
		redirect_to request.referer
	end

end