class TrainingDrillsController     < AuthenticatedController
	def new
		if request.xhr?
			@training_drill = TrainingDrill.new
			render partial: "shared/drills/new_training_drill_form"
		else
			render
		end
	end

	def create
		if request.xhr?
			@training_drill = current_user.training_drills.build(params[:training_drill])
			if @training_drill.save
				render text: "{\"id\":#{@training_drill.id}}"
				return
			else
				flash[:error] = "Failed creating drill"
				render text: "Error"
				return
			end
		end
		render text: "nothing here."
	end

	def show
		render text: "ok"
	end

	def select
		if request.xhr?
			@available_drills = current_user.training_drills.all
			if @available_drills.any?
				render partial: "shared/drills/existing_training_drill_selector"
			else
				render partial: "shared/drills/new_training_drill_form"
			end
			return
		end
		render text: "nothing here."
	end
end