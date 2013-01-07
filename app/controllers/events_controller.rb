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
					attendant = @event.attendants.find_by_user_id(@user.id)
					if attendant.nil?
						attendant = @event.attendants.build(user: @user, event: @event)
					end
					attendant.save
					user.save
				end
			end
			@event.save
		end
		redirect_to request.referer
	end
end