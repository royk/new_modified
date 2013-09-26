class TrainingDrillsController     < AuthenticatedController

  before_filter	:correct_user, only: [:show]

	def init
		render partial: "shared/drills/new_or_existing_form"
	end
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
				render json: {payload: {id: @training_drill.id}}
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
    @results = @training_drill.training_drill_results.all(include: :training_session, order:'training_sessions.date')
    if @results.any?
      @start_date = @results.first.training_session.date
      @end_date = @results.last.training_session.date
      @sessions = current_user.training_sessions.where("created_at BETWEEN ? AND ? ", @start_date, @end_date).all
    end
	end

	def select
		if request.xhr?
			@available_drills = current_user.training_drills.find(:all, order: "updated_at DESC")
			if @available_drills.any?
				render partial: "shared/drills/existing_training_drill_selector"
			else
				render partial: "shared/drills/new_training_drill_form"
			end
			return
		end
		render text: "nothing here."
  end

  private
    def correct_user
      unless current_user.admin?
        @training_drill = current_user.training_drills.find_by_id(params[:id])
        redirect_to root_url if @training_drill.nil?
      else
        @training_drill = TrainingDrill.find(params[:id])
      end
    end
end