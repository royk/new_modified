class TrainingSessionsController  < AuthenticatedController
	include VideoHelper

	def show
		@trainingSession = TrainingSession.find(params[:id])
	end

	def new
		new! { request.referer }
	end

	def create
		@trainingSession = current_user.training_sessions.build(params[:training_session])
		success = attach_video(@trainingSession, params)
		success = attach_drills(@trainingSession, params[:drills]) if success
		success = @trainingSession.save if success
		if success
			flash[:success] = "Session saved"
		else
			flash[:error] = "Failed saving Session. Please make sure you filled all the required information." if flash[:error].blank?
		end
		redirect_to request.referer
	end

	def attach_drills(entity, params)
		i=0
		until params[("sessionDrill_name_"+i.to_s).to_sym].nil?
			name = params[("sessionDrill_name_"+i.to_s).to_sym]
			total = params[("sessionDrill_total_"+i.to_s).to_sym]
			drops =params[("sessionDrill_drops_"+i.to_s).to_sym]
			if !name.empty? && !total.empty? && !drops.empty?
				@drill = DrillResult.new()
				@drill.name = name
				@drill.drops = drops.to_i
				@drill.total_contacts = total.to_i
				@drill.training_session_id = entity.id
				if @drill.save
					entity.drill_results ||= []
					entity.drill_results << @drill
				end
			end
			i+=1
		end
		return true
	end
end