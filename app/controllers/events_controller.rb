class EventsController < AuthenticatedController
	skip_before_filter :signed_in_user, only: [:index, :show]

	def create
		create! { request.referer }
	end

	def update
		@event = Event.find(params[:id])
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