class EventsController < AuthenticatedController
	skip_before_filter :signed_in_user, only: [:index, :show]

	def index
		@past_events = Event.where("start_date < ?", Time.now).order('start_date desc')
		@upcoming_events = Event.where("start_date >= ?", Time.now).order('start_date desc')
	end

	def create
		create! { request.referer }
	end

	def update
		
		unless @event.nil?
			if params[:attendant]
				@user = User.find(params[:attendant])
				unless @user.nil?
					@event.attendants << @user
				end
			end
			@event.save
		end
		redirect_to request.referer
	end
end