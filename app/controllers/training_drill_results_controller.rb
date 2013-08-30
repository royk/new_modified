class TrainingDrillResultsController < AuthenticatedController
	def new
		if request.xhr?
			render partial: "shared/drill_results/new"
			return
		end
		render text: "nothing here."
	end

	def create
		@training_drill_result = TrainingDrillResult.build(params[:training_drill_result])
		if @training_drill_result.save
			render partial: "shared/drill_results/show"
			return;
		else
			flash[:error] = "Failed saving results"
			render text: "Error"
			return
		end
		render text: "nothing here."
	end
end