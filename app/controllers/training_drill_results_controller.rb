class TrainingDrillResultsController < AuthenticatedController
	def new
		@training_drill = TrainingDrill.find_by_id(params[:training_drill][:id])
		unless @training_drill.nil?
      @training_drill.touch
			if request.xhr?
				render partial: "shared/drill_results/new"
				return
			end
		end
		render text: "nothing here."
	end

	def create
		i=0
		dropsArray = []
		drops = ""
		until params[("drops_count"+i.to_s).to_sym].nil?
			drops = params[("drops_count"+i.to_s).to_sym]
			unless drops.empty?
				dropsArray.push(drops);
			end
			i+=1
		end
		drops = dropsArray.join(",")
		params[:training_drill_result][:drops] = drops
		@training_drill_result = TrainingDrillResult.create(params[:training_drill_result])
		if @training_drill_result.save
			render json: {content: render_to_string(partial: "shared/drill_results/show")}
			return;
		else
			flash[:error] = "Failed saving results"
			render text: "Error"
			return
		end
		render text: "nothing here."
	end
end