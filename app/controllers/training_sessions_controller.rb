class TrainingSessionsController  < AuthenticatedController
	include VideoHelper
	before_filter	:correct_user, only: [:destroy, :update]
  before_filter :check_for_mobile

	def show
    @trainingSession = TrainingSession.find(params[:id])
    unless @trainingSession.nil?
      if request.xhr?
        # used for reloading session during recording.
        @training_drill_results = @trainingSession.training_drill_results.all
        resultsContent = ""
        @training_drill_results.each do |r|
          @training_drill_result = r
          resultsContent = resultsContent + render_to_string(partial: "shared/drill_results/show")
        end
        render json: {title: render_to_string(partial: "shared/sessions/show_title"), resultsContent: resultsContent}
      else
        previousSessions = TrainingSession.where("user_id = ? AND date IS NOT NULL AND date<?", @trainingSession.user_id, @trainingSession.date).order("date DESC").all
        if previousSessions!=nil && previousSessions.any?
          @previousSession = previousSessions.first
        end
      end
    end
	end

	def new
		new! { request.referer }
	end

	def destroy
		@trainingSession.destroy
		flash[:success] = "Session deleted"
		redirect_to root_url
	end

	def create
		success = true
		begin
			params[:training_session][:date] = DateTime.strptime(params[:training_session][:date], "%m/%d/%Y")
			params[:training_session][:startTime] = params[:training_session][:startTime].to_datetime
		rescue
			success = false
			message = "Failed saving Session: Invalid date or time."
		end
		if success
			@trainingSession = current_user.training_sessions.build(params[:training_session])
=begin
			success = attach_video(@trainingSession, params)
			success = attach_drills(@trainingSession, params[:drills]) if success
=end
			success = @trainingSession.save if success

			message = "Session saved"
			unless success
				message = flash[:error].blank? ? "Failed saving Session. Please make sure you filled all the required information." : flash[:error]
			end
		end
		render json: {message: message, success:success, payload: {id: @trainingSession.id}, content: render_to_string(partial: "shared/sessions/show_title")}
	end

	def update
		success = true
		if defined?(params[:training_session][:endTime])
			params[:training_session][:endTime] = params[:training_session][:endTime].to_datetime;
			@trainingSession.update_attributes(params[:training_session])
			render json: {message: "Session updated", success:success}
			return
		end
		begin
			params[:training_session][:date] = DateTime.strptime(params[:training_session][:date], "%m/%d/%Y")
		rescue
			success = false
			message = "Failed updating Session: Invalid date."
		end

		if (success)
			@trainingSession.update_attributes(params[:training_session])
			success = attach_video(@trainingSession, params)
			success = attach_drills(@trainingSession, params[:drills]) if success
			success = @trainingSession.save if success
			if success
				message = "Session updated"
			else
				message = flash[:error].blank? ? "Failed updating Session. Please make sure you filled all the required information." : flash[:error]
			end
		end
		render json: {message: message, success:success}
	end

	def attach_drills(entity, params)
		i=0
		until params[("sessionDrill_name_"+i.to_s).to_sym].nil?
			name = params[("sessionDrill_name_"+i.to_s).to_sym]
			total = params[("sessionDrill_total_"+i.to_s).to_sym]
			drops =params[("sessionDrill_drops_"+i.to_s).to_sym]
			if !name.empty? && !total.empty? && !drops.empty?
				@drill = entity.drill_results.find_by_order_index(i)
				is_new = false
				if @drill.nil?
					@drill = DrillResult.new() if @drill.nil?
					is_new = true
				end
				@drill.name = name
				@drill.drops = drops
				@drill.order_index = i
				@drill.total_contacts = total.to_i
				@drill.total_contacts = 1 if @drill.total_contacts==0
				@drill.training_session_id = entity.id
				if @drill.save && is_new
					entity.drill_results ||= []
					entity.drill_results << @drill
				end
			end
			i+=1
		end
		return true
	end

	def destroy
		@trainingSession.destroy
		flash[:success] = "Session deleted"
		redirect_to root_url
	end

	private


	def correct_user
		unless current_user.admin?
			@trainingSession = current_user.training_sessions.find_by_id(params[:id])
			redirect_to root_url if @trainingSession.nil?
		else
			@trainingSession = TrainingSession.find(params[:id])
		end
	end
end