class TrainingDrillResultsController < AuthenticatedController
	def new
		@training_drill = TrainingDrill.find_by_id(params[:training_drill][:id])
		unless @training_drill.nil?
			if request.xhr?
				render partial: "shared/drill_results/new"
				return
			end
		end
		render text: "nothing here."
	end

	def create
		@training_drill_result = TrainingDrillResult.create(params[:training_drill_result])
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